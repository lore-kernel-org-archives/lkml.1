Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbXJBJqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbXJBJqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbXJBJqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:46:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34621 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbXJBJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:46:00 -0400
Date: Tue, 2 Oct 2007 11:45:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Chua <jeff.chua.linux@gmail.com>,
       rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20071002094559.GA21895@atrey.karlin.mff.cuni.cz>
References: <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com> <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl> <1188822917.3406.0.camel@chaos> <20070904072744.GA30474@atrey.karlin.mff.cuni.cz> <1189713695.3974.23.camel@chaos> <20070914123816.GE1671@elf.ucw.cz> <1189774257.3100.7.camel@chaos> <1189775743.3100.9.camel@chaos> <1189849781.4319.5.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189849781.4319.5.camel@chaos>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Venki sent me an initial patch, but it has issues with the notify
> > > ordering. Find below my "cache the broadcast flags" version for testing.
> > 
> > Hmmpf, the flag is still cleared when the cpu goes offline. Need to take
> > a closer look.
> 
> I finally tracked it down. There were several ways to turn the box into
> a brick. Sigh !
> 
> Can you please test the combo patch below ?

Sorry, I was on holidays. I assume this is in -rc9 or so, already?
Yes, seems so.

Unfortunately, cpu hotplug seems to be still behaving strangely in
-rc9. I can echo 0 > online (and cpu will go down). I do echo 0 >
online, again, and I get -EBUSY. Good. But I try to do echo 1 >
online, and get -EBUSY, too... and that's bad :-(.

root@amd:/sys/devices/system/cpu/cpu1# echo 0 > online
root@amd:/sys/devices/system/cpu/cpu1# echo 0 > online
-bash: echo: write error: Device or resource busy
root@amd:/sys/devices/system/cpu/cpu1# echo 1 > online
-bash: echo: write error: Device or resource busy
root@amd:/sys/devices/system/cpu/cpu1# uname -a
Linux amd 2.6.23-rc9 #507 SMP Tue Oct 2 09:58:40 CEST 2007 i686
GNU/Linux

Kernel says:

Oct  2 11:42:12 amd log1n[1436]: ROOT LOGIN on `tty1'
Oct  2 11:42:56 amd kernel: CPU 1 is now offline
Oct  2 11:42:56 amd kernel: SMP alternatives: switching to UP code

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
