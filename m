Return-Path: <linux-kernel-owner+w=401wt.eu-S1030510AbXC2Rt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510AbXC2Rt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 13:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934307AbXC2Rt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 13:49:26 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2892 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688AbXC2RtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 13:49:25 -0400
From: Mariusz =?utf-8?q?Koz=C5=82owski?= <m.kozlowski@tuxland.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc5-mm1
Date: Thu, 29 Mar 2007 20:01:40 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>, Matt Mackall <mpm@selenic.com>
References: <20070326205706.a750bb35.akpm@linux-foundation.org> <20070328202542.GS16477@stusta.de> <200703282249.48130.m.kozlowski@tuxland.pl>
In-Reply-To: <200703282249.48130.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703292001.41255.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > > > 	I run 2.6.21-rc4-mm1 with no hangs for a week.
> > > > Then when 2.6.21-rc5-mm1 showed up so I switched to it. Unfortunately
> > > > today my laptop hunged twice in a similar way as described here:
> > > > 
> > > > http://www.ussg.iu.edu/hypermail/linux/kernel/0703.0/index.html#1165
> > > 
> > > It's not good that we went backwards between those two releases.
> > > 
> > > > The difference is that it happened when I closed the lid in my laptop.
> > > > When reopend it the box was frozen (ACPI?). Again disk I/O was dead
> > > > so nothing was found in syslog.
> > > 
> > > Adrian, does this look like any of the bugs whcih you're monitoring?
> > >...
> > 
> > Is it also present in 2.6.21-rc5?
> 
> Don't know. I usualy test -mm series. Will test tommorow and let you know
> after some reasonable uptime.
> 
> > Is it also present with CONFIG_NO_HZ=n?
> 
> Don't know. Did not try recently. Will let you know.
> 
> It takes time as these hangs are not easy to trigger. With 2.6.21-rc2-mm1
> it was easy -> push the system and watch it die in minutes. With
> 2.6.21-rc5-mm1 it takes hours (3 hangs in ~15 hours) and not sure how to
> trigger it. It just happens from time to time.

Ok. CONGIG_NO_HZ=n and uptime ~12 hours, netconsole loaded, and no hangs
... until I moved my laptop. The same scenario happened yesterday during the
last hang. I started playing and repeating some steps which I naturally do when
I move my laptop.

An hour later I came to this -> steps to hang 2.6.21-rc5-mm1 on my laptop:
1. boot the system and login as root
2. load netconsole (insmod netconole.ko netconsole=blah... blah...)
3. unplug the cable (link goes down)
4. system is frozen until forced to reboot

This is verified and repeatable _every_ single time I tried. Unfortunately
the last thing seen on the screen before system is frozen is 'eth0: link down'.
So my guess is that when hunting for hangs I found something else that can hang
my laptop (netconsole that is).

Regards,

	Mariusz Kozlowski

