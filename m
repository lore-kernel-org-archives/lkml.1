Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbXCTWSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbXCTWSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXCTWSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:18:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55265 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbXCTWSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:18:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: Re: Suspend to RAM doesn't work anymore in 2.6.21
Date: Tue, 20 Mar 2007 23:21:28 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       linux-acpi@vger.kernel.org
References: <200703191350.44105.tobias.doerffel@gmail.com> <200703192243.20836.rjw@sisk.pl> <200703200154.49695.tobias.doerffel@gmail.com>
In-Reply-To: <200703200154.49695.tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703202321.28808.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 01:54, Tobias Doerffel wrote:
> On Monday 19 March 2007 22:43:20 you wrote:
> > Hi,
> >
> > On Monday, 19 March 2007 13:50, Tobias Doerffel wrote:
> > > Hi,
> > >
> > > Suspend to RAM used to work fine on my computer (Intel Core Duo, 1 GB
> > > RAM, Intel 82801G (ICH7-chipset) mainboard, NVIDIA-gfx-card,
> > > tg3-ethernet) up to 2.6.20.3. But no matter which rc of 2.6.21 I use,
> > > suspend to RAM doesn't work anymore. Up to rc3 even suspending stopped at
> > > "suspending console" which appearently seems to be fixed in rc4. I tried
> > > rc4-git4 with minimal config (no dyndicks, no HRT, no MSI, no sound, no
> > > bluetooth, no PCMCIA, no WLAN, no USB, no cpufreq) but still I can't
> > > resume properly. Caps works and I can login through SSH. Back to a more
> > > complete config (sound, MMC, WLAN, PCMCIA - still no dynticks or HRT -
> > > see attachment "config") I get exactly the same behaviour.
> > >
> > > When logged in through SSH after resume I saved output of dmesg (which
> > > includes full power management debug messages), see
> > > attachement "dmesg-resume". The system basically seems to be back but lot
> > > of things do not work such as loading/unloading e.g. my WLAN-driver
> > > (ipw3945), running "top" or "dstat" etc.   "uptime" always returns 0 min,
> > > even with power management debug disabled.
> > >
> > > Kernel:
> > > Linux version 2.6.21-rc4 (gcc version 4.1.2 20061115 (prerelease) (Debian
> > > 4.1.1-21)) #23 SMP PREEMPT Mon Mar 19 12:27:56 CET 2007
> I made some further investigations on this issue. A complete bisect between 
> 2.6.20 and 2.6.21-rc4-git4 stops at a stage 
> (a4bbb810dedaecf74d54b16b6dd3c33e95e1024c) where I'm not able to compile the 
> kernel anymore because of compiling-errors in arch/i386/kernel/setup.c 
> (ACPI-related compiling errors). Stepping some revisions back until it 
> compiled again resume didn't work either.
> 
> So I started all over again with bisect only on arch/i386 and ended up at 
> ceb6c46839021d5c7c338d48deac616944660124 as the bad commit. But this file 
> seems to be some kind of finalization of a series of patches ("ACPICA: Remove 
> duplicate table manager") so I guess it's hard to debug this thing...
> 
> > Can you please do
> >
> > # echo test > /sys/power/disk
> > # echo disk > /sys/power/state
> >
> > (the system should freeze tasks, suspend devices, disable nonboot CPUs,
> > wait for 5 seconds, enable nonboot CPUs, resume devices, thaw tasks and
> > return to your command prompt) and see if you can reproduce the problem?
> Same problem here. Works fine in 2.6.20 as well as before 
> ceb6c46839021d5c7c338d48deac616944660124. Doesn't work on recent 
> 2.6.21-rc4-git4.
> 
> Any more information I can give?

Well, this looks like an ACPI problem, and actually a regression.

I think you can open a bugzilla entry in the ACPI category and put the
above information in there (please add rjwysocki@sisk.pl to the entry's Cc
list).

Greetings,
Rafael
