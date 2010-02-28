Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032003Ab0B1UN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:13:57 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:49297 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031966Ab0B1UN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:13:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wNzYSj8R1aQ80FQz7IE62D79Jtzb2OrW6l+hg6XP6Wu0/36izZIhbMIx5MLYrOxhzx
         Y423I0MW/zPXVUOIs1Iirmgqj//cMNwEfZN67rDQtuYHlZFLJD22nf1bloaGT5gZM2qm
         Puh5IHujA9Pe8WCWOYQBjQ8Si348IyqzNeQJE=
MIME-Version: 1.0
In-Reply-To: <201002282054.32204.rjw@sisk.pl>
References: <201002272143.22156.rjw@sisk.pl> <201002281313.38483.rjw@sisk.pl>
	 <1267374785.1929.2.camel@i7.satnam> <201002282054.32204.rjw@sisk.pl>
Date: Mon, 1 Mar 2010 01:43:54 +0530
Message-ID: <3f9a31f41002281213y2d65ae37xf9934a0775d8d9ee@mail.gmail.com>
Subject: Re: [PATCH] Driver core: Reduce the level of request_firmware() 
	messages
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

On Mon, Mar 1, 2010 at 1:24 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
>>
>> On Sun, 2010-02-28 at 13:13 +0100, Rafael J. Wysocki wrote:
>> > On Sunday 28 February 2010, Jaswinder Singh Rajput wrote:
>> > > On Sun, Feb 28, 2010 at 2:13 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
>> > > >
>> > > > The messages from _request_firmware() informing that firmware is
>> > > > being requested or built-in firmware is going to be used are printed
>> > > > at KERN_INFO, which produces lots of noise on systems with huge
>> > > > numbers of AMD CPUs.  Reduce the level of these messages to
>> > > > KERN_DEBUG to get rid of that noise.
>> > > >
>> > >
>> > > Which firmware we are using is very useful information. Because of
>> > > huge numbers of CPUs it seems noise then better provide the
>> > > information for first cpu and for the rest of the CPUs you can show by
>> > > KERN_DEBUG.
>> >
>> > That would have been better indeed, but the problem is _request_firmware()
>> > doesn't allow us to change the level of its messages on demand.
>>
>> Can we try this :
>>
>>       if (smp_processor_id())
>>               dev_dbg(..);
>>       else
>>               dev_info(..);
>
> Well, it doesn't look particularly nice, does it?
>
> Besides, say we're requesting firmware for a non-CPU device which happens
> to run on CPU1.  Then, dev_dbg() will be used, which most likely is not what we
> want.
>

Yes, you are right. But atleast can you try it once and show the
output with and without this.

Thanks,
--
Jaswinder.
