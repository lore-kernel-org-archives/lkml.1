Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0CIXcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:32:48 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33717 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0CIXcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:32:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YNRgXWGWh0Yz3AoPGrimgIuKgP8ao48Dpt2D67GQ7sdpeCktqNpYjTkx7LlMUNseR1
         KVHc3MOInsV3ztFuMDcXrJG4Vzcs1whbUHYmY4o1EcGMI98ge0uMFz+ITGB3C76gzxZd
         ZZ9eqztvo+hC1U5rQj5dCMS3b9rgP80LZEPkI=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1003091729320.1693-100000@iolanthe.rowland.org>
References: <d9def9db1003091309p3aa84879lb586cb0406f62693@mail.gmail.com>
	 <Pine.LNX.4.44L0.1003091729320.1693-100000@iolanthe.rowland.org>
Date: Wed, 10 Mar 2010 00:32:42 +0100
Message-ID: <d9def9db1003091532icb671efy48b30185b86effcb@mail.gmail.com>
Subject: Re: USBFS Memory allocation Bug
From: Markus Rechberger <mrechberger@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 11:31 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 9 Mar 2010, Markus Rechberger wrote:
>
>> Hi,
>>
>> I just stumbled around following issue:
>>
>> [275835.163502] Pid: 14298, comm: mediasrv Not tainted 2.6.33 #7
>> [275835.163505] Call Trace:
>> [275835.163514]  [<ffffffff810df7a6>] __alloc_pages_nodemask+0x5b6/0x700
>> [275835.163520]  [<ffffffff8110c667>] alloc_pages_current+0x87/0xd0
>> [275835.163525]  [<ffffffff810dcf79>] __get_free_pages+0x9/0x50
>> [275835.163529]  [<ffffffff81114f2b>] __kmalloc+0x13b/0x1f0
>> [275835.163535]  [<ffffffff813a18ef>] proc_do_submiturb+0x2ff/0x9d0
>> [275835.163539]  [<ffffffff813a26b9>] usbdev_do_ioctl+0x6f9/0x14a0
>
> The mediasrv program tried to allocate more memory than was available.
> It's unfortunate but it's not a bug.
>

Yes, 'unfortunate' is what bothers me about this, it can only be
around 198kbyte what the app can try to request (everything else will
fail internally).
The system has 4 gig ram, around 1 gig was not allocated (according to
free). not sure but I guess the pool where kmalloc tried to get the
memory from was out of memory, at least the OOM manager was not active
at all either and the rest of the system was more or less running
smoothly at this time.

Markus
