Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZI1BxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZI1BxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 21:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZI1BxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 21:53:19 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:58122 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZI1BxS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 21:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=v0PnWSpmse6++l3VvENtUqy147Ms/YmqBRh9e3bSNOZG/G74A0mXoebjI06ANQ2gWI
         bMvnkAqHbr+NiPxxHtZMbhAosKWuU7h1vmSZ7B5a2Vn/Q2VQytckHasfg3mD4llcybuf
         /2GvsTZJRiFhLLpFH7sjAhTkhOi8g2pXAtvWI=
MIME-Version: 1.0
In-Reply-To: <200909271746.30542.rjw@sisk.pl>
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com>
	 <8db1092f0909270325j67825cem82fc93cf19336d6f@mail.gmail.com>
	 <2674af740909270701u6febabdbpc5c772fabc193b32@mail.gmail.com>
	 <200909271746.30542.rjw@sisk.pl>
Date: Mon, 28 Sep 2009 09:53:22 +0800
Message-ID: <2674af740909271853r73bb70f7s81d7ddd1b09f18b5@mail.gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 
	hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 
	__sysdev_resume+0xc3/0xe0()
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clemens@ladisch.de, venkatesh.pallipadi@intel.com, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 11:46 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday 27 September 2009, Yong Zhang wrote:
>> On Sun, Sep 27, 2009 at 6:25 PM, Maciej Rutecki
>> <maciej.rutecki@gmail.com> wrote:
>> > 2009/9/27 Yong Zhang <yong.zhang0@gmail.com>:
>> >>
>> >> Oops, TABLE is corrupted. Please use the attachment.
>> >
>> > kernel/time/timekeeping.c: In function ‘timekeeping_resume’:
>> > kernel/time/timekeeping.c:577: error: ‘xtime_locks’ undeclared (first
>> > use in this function)
>> > kernel/time/timekeeping.c:577: error: (Each undeclared identifier is
>> > reported only once
>> > kernel/time/timekeeping.c:577: error: for each function it appears
>> > in.)
>> > make[3]: *** [kernel/time/timekeeping.o] Błąd 1
>> > make[2]: *** [kernel/time] Błąd 2
>> >
>> >
>> > I change:
>> > write_seqlock(&xtime_locks);
>> > to:
>> > write_seqlock(&xtime_lock);
>> >
>>
>> Oh, typo error.
>>
>> > Corrected patch in attachment.
>> >
>> > First warning has gone, but still I have this:
>> > [  120.868049] SMP alternatives: switching to UP code
>> > [  120.872570] CPU0 attaching NULL sched-domain.
>> > [  120.872574] CPU1 attaching NULL sched-domain.
>> > [  120.872581] CPU0 attaching NULL sched-domain.
>> > [  120.872787] CPU1 is down
>> > [  120.872846] Extended CMOS year: 2000
>> > [  120.872945] PM: Creating hibernation image:
>> > [  120.876009] PM: Need to copy 107120 pages
>> > [  120.872009] PM: Restoring platform NVS memory
>> > [  120.872009] CPU0: Thermal monitoring handled by SMI
>> > [  120.872009] Extended CMOS year: 2000
>> > [  120.872009] ------------[ cut here ]------------
>> > [  120.872009] WARNING: at drivers/base/sys.c:353
>> > __sysdev_resume+0xc3/0xe0()
>> > [  120.872009] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
>> > [  120.872009] Interrupts enabled after timekeeping_resume+0x0/0x1c0
>>
>> Irq is enabled after timekeeping_resume(), the previous patch do something
>> sensible. But we even don't know when the irq is enabled. such as in
>> timekeeping_resume() or before enter timekeeping_resume(). But it
>> seem that this is not due to timekeeping_resume(). Instead I'm afraid
>> it's caused by buggy driver.
>
> Interrupts are disabled by the suspend core code right before sysdev_suspend(),

You are quite right. Thanks for your clarification.

-Yong

> so device drivers cannot make this happen.  One of the sysdevs is doing this.
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
