Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZI0PpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZI0PpW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 11:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZI0PpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 11:45:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60350 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZI0PpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 11:45:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [2.6.31-git17] WARNING: at kernel/hrtimer.c:648 hres_timers_resume+0x40/0x50()/WARNING: at drivers/base/sys.c:353 __sysdev_resume+0xc3/0xe0()
Date: Sun, 27 Sep 2009 17:46:30 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       clemens@ladisch.de, venkatesh.pallipadi@intel.com, gregkh@suse.de
References: <8db1092f0909270105x4b49daf8k268e453d2379020c@mail.gmail.com> <8db1092f0909270325j67825cem82fc93cf19336d6f@mail.gmail.com> <2674af740909270701u6febabdbpc5c772fabc193b32@mail.gmail.com>
In-Reply-To: <2674af740909270701u6febabdbpc5c772fabc193b32@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909271746.30542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009, Yong Zhang wrote:
> On Sun, Sep 27, 2009 at 6:25 PM, Maciej Rutecki
> <maciej.rutecki@gmail.com> wrote:
> > 2009/9/27 Yong Zhang <yong.zhang0@gmail.com>:
> >>
> >> Oops, TABLE is corrupted. Please use the attachment.
> >
> > kernel/time/timekeeping.c: In function ‘timekeeping_resume’:
> > kernel/time/timekeeping.c:577: error: ‘xtime_locks’ undeclared (first
> > use in this function)
> > kernel/time/timekeeping.c:577: error: (Each undeclared identifier is
> > reported only once
> > kernel/time/timekeeping.c:577: error: for each function it appears
> > in.)
> > make[3]: *** [kernel/time/timekeeping.o] Błąd 1
> > make[2]: *** [kernel/time] Błąd 2
> >
> >
> > I change:
> > write_seqlock(&xtime_locks);
> > to:
> > write_seqlock(&xtime_lock);
> >
> 
> Oh, typo error.
> 
> > Corrected patch in attachment.
> >
> > First warning has gone, but still I have this:
> > [  120.868049] SMP alternatives: switching to UP code
> > [  120.872570] CPU0 attaching NULL sched-domain.
> > [  120.872574] CPU1 attaching NULL sched-domain.
> > [  120.872581] CPU0 attaching NULL sched-domain.
> > [  120.872787] CPU1 is down
> > [  120.872846] Extended CMOS year: 2000
> > [  120.872945] PM: Creating hibernation image:
> > [  120.876009] PM: Need to copy 107120 pages
> > [  120.872009] PM: Restoring platform NVS memory
> > [  120.872009] CPU0: Thermal monitoring handled by SMI
> > [  120.872009] Extended CMOS year: 2000
> > [  120.872009] ------------[ cut here ]------------
> > [  120.872009] WARNING: at drivers/base/sys.c:353
> > __sysdev_resume+0xc3/0xe0()
> > [  120.872009] Hardware name: HP Compaq nx6310 (EY501ES#AKD)
> > [  120.872009] Interrupts enabled after timekeeping_resume+0x0/0x1c0
> 
> Irq is enabled after timekeeping_resume(), the previous patch do something
> sensible. But we even don't know when the irq is enabled. such as in
> timekeeping_resume() or before enter timekeeping_resume(). But it
> seem that this is not due to timekeeping_resume(). Instead I'm afraid
> it's caused by buggy driver.

Interrupts are disabled by the suspend core code right before sysdev_suspend(),
so device drivers cannot make this happen.  One of the sysdevs is doing this.

Thanks,
Rafael
