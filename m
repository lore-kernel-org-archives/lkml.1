Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYI3FVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYI3FVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYI3FVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:21:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:35256 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbYI3FVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:21:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=I3VQIomxDn6hxL6vZypxy/ioWw9ZluzvuIiyfMn3eaT2eWXVIunTYc4Ew8YhkYMzJ8
         dVCLJFA+Bb/8oi1fb5Fil97xAfatyHchahfiIjdAlIoHn0Uz1A0RnR6+uwfc9ZmLS9ZC
         VmAhE4dIfqDKZcNXaiyT6g3hcHQBj0E4c3BXU=
Message-ID: <dd18b0c30809292221r2225e05cr1a8b686ab95c4e83@mail.gmail.com>
Date: Mon, 29 Sep 2008 22:21:28 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: BUG kmalloc-16: Object already free
Cc: "Rabin Vincent" <rabin@rab.in>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <1222732059.1825.29.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809281554g11ac7275x819812935b6ac68f@mail.gmail.com>
	 <20080929181752.GA2027@debian>
	 <1222732059.1825.29.camel@violet.holtmann.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 4:47 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Rabin,
>
>> > After frying my system, I'm finally up and
>> > running. Not sure if this was due to a git-pull
>> > (only be a few days since the last pull), or what:
>> > when waking from suspend I see this
>> > (I know it says tainted in it, so this will be the only noise you'll
>> > here from me on this);
>> >
>> > [  274.327003] =============================================================================
>> > [  274.327528] BUG kmalloc-16: Object already free
>> > [  274.327877] -----------------------------------------------------------------------------
>> > [  274.327879]
>> > [  274.327890] INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=0
>> > cpu=1 pid=3763
>> > [  274.327899] INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=0
>> > cpu=1 pid=3763
>> > [  274.327905] INFO: Slab 0xc139a100 objects=64 used=62 fp=0xdcd08100
>> > flags=0x400000c3
>>
>> There's a commit in the latest git which looks like it will solve the
>> btusb suspend/resume issues: 5fbcd260.. ("[Bluetooth] Fix USB disconnect
>> handling of btusb driver").
>>
>> Marcel / linux-bluetooth, I think this double free is a separate issue
>> with the error handling, and the following patch should fix it.
>>
>> ---
>> From: Rabin Vincent <rabin@rab.in>
>> Subject: [PATCH] btusb, bpa10x: fix double frees on error paths
>>
>> Justin Mattock reported this double free in btusb:
>>
>>   BUG kmalloc-16: Object already free
>>   -----------------------------------------------------------------------------
>>
>>   INFO: Allocated in btusb_open+0x82/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
>>   INFO: Freed in btusb_open+0x13d/0x16f [btusb] age=3D0 cpu=3D1 pid=3D3763
>>
>> This occurs because the urb's transfer buffer is being freed separately
>> in the error path even though the URB_FREE_BUFFER transfer_flag is set
>> on the urb.
>>
>> There are similar cases elsewhere in btusb and in bpa10x.  Fix all of
>> them by removing the additional kfree()'s.
>
> I haven't verified it yet, but it looks like a good catch. Let me double
> check this on my test machine. Weird that we never noticed this before
> since I have been using the btusb driver for a very long time now.
>
> Regards
>
> Marcel
>
>
>

This was the first time I've seen this,
I can apply the patch myself, but first
I need to figure why dbus can be such a bitch : )
Need to figure out how to write dbus rules(if this is the case)
keep getting the permissions denied crap.

-- 
Justin P. Mattock
