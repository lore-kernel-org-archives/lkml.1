Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZDMDCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZDMDCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZDMDCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:02:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:48594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZDMDCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,178,1239001200"; 
   d="scan'208";a="505884950"
Subject: Re: High latency on /sys/class/thermal
From: Zhang Rui <rui.zhang@intel.com>
To: Tiago =?ISO-8859-1?Q?Sim=F5es?= Batista <tiagosbatista@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <20090413032817.32df07a0@gmail.com>
References: <20090411155612.5808570c@ua.pt>
	 <20090411121416.91fe3c88.akpm@linux-foundation.org>
	 <20090411231611.7c5f9b69@ua.pt>	<20090412170320.52e374df@gmail.com>
	 <1239587022.7661.202.camel@rzhang-dt>  <20090413032817.32df07a0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Apr 2009 11:02:51 +0800
Message-Id: <1239591771.7661.222.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC Alexey because this is EC related.
The high letancy is probably spent on accessing the EC address space in
_TMP method.

Tiago,
please make sure your kernel is built with CONFIG_ACPI_DEBUG set
and then
1. boot with printk.time=1 acpi.debug_level=0x07
acpi.debug_layer=0x04000018
2. run ﻿cat /sys/class/thermal/thermal_zone0/temp
3. attach the full dmesg output.

thanks,
rui

On Mon, 2009-04-13 at 10:28 +0800, Tiago Simões Batista wrote:
> acpidump output attached.
> 
> I found no latency on battery iterface, included is another poke at the
> thermal zone for comparison.
> 
> This problem is still present, but at the moment, I shut down the
> sensors-applet on the gnome panel, so that it no longer makes
> gnome-panel stall.
> 
> $ time cat /sys/class/thermal/thermal_zone0/temp 
> 49000
> 
> real	0m13.476s
> user	0m0.001s
> sys	0m0.001s
> $ time cat /sys/class/power_supply/BAT0/*
> 0
> 29
> 0
> 0
> cat: /sys/class/power_supply/BAT0/device: Is a directory
> 582640000
> 65120000
> 18710000
> SMP-SONY
> 04ZL
> cat: /sys/class/power_supply/BAT0/power: Is a directory
> 0
> 0
> 1
> Full
> cat: /sys/class/power_supply/BAT0/subsystem: Is a directory
> Li-ion
> 270
> Battery
> PHYSDEVPATH=/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:0b/PNP0C09:00/ACPI0001:00/ACPI0002:00
> PHYSDEVBUS=acpi
> PHYSDEVDRIVER=sbs
> POWER_SUPPLY_NAME=BAT0
> POWER_SUPPLY_TYPE=Battery
> POWER_SUPPLY_STATUS=Full
> POWER_SUPPLY_PRESENT=1
> POWER_SUPPLY_TECHNOLOGY=Li-ion
> POWER_SUPPLY_VOLTAGE_MIN_DESIGN=14800000
> POWER_SUPPLY_VOLTAGE_NOW=15611000
> POWER_SUPPLY_CURRENT_NOW=0
> POWER_SUPPLY_CURRENT_AVG=0
> POWER_SUPPLY_POWER_NOW=0
> POWER_SUPPLY_POWER_AVG=0
> POWER_SUPPLY_CAPACITY=29
> POWER_SUPPLY_ENERGY_FULL_DESIGN=65120000
> POWER_SUPPLY_ENERGY_FULL=582640000
> POWER_SUPPLY_ENERGY_NOW=18710000
> POWER_SUPPLY_TEMP=270
> POWER_SUPPLY_MODEL_NAME=04ZL
> POWER_SUPPLY_MANUFACTURER=SMP-SONY
> 14800000
> 15611000
> 
> real	0m0.110s
> user	0m0.001s
> sys	0m0.004s
> 
> 
> On Mon, 13 Apr 2009 09:43:42 +0800
> Zhang Rui <rui.zhang@intel.com> wrote:
> 
> > this sounds like an EC problem to me. please attach the acpidump
> > output. is there a long latency when you poke other ACPI devices, say
> > battery?
> > 
> > thanks,
> > rui
> > 
> > On Mon, 2009-04-13 at 00:03 +0800, Tiago Simões Batista wrote:
> > > On Sat, 11 Apr 2009 23:16:11 +0100
> > > Tiago Simões Batista <tiagosbatista@gmail.com> wrote:
> > > 
> > > > Sorry about the noise, by brain was stopped when I sent the last
> > > > mail, please ignore the From address, it is wrong!
> > > > 
> > > > On Sat, 11 Apr 2009 12:14:16 -0700
> > > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > (cc linux-acpi)
> > > > > 
> > > > > On Sat, 11 Apr 2009 15:56:12 +0100 "Tiago Sim__es Batista"
> > > > > <tiagosbatista@gmail.com> wrote:
> > > > > 
> > > > > > Hi all
> > > > > > 
> > > > > > Yesterday, I recompiled my kernel (git + tuxonice)
> > > > > > v2.6.30-rc1-1002-gac91f91, there were a couple of issues, the
> > > > > > main one is ilustrated bellow.
> > > > > > 
> > > > > > I am not familiar with the kernel code, but if you give me
> > > > > > some pointers, I will be glad to investigate this further
> > > > > > 
> > > > > > $time cat /sys/class/thermal/thermal_zone0/temp 
> > > > > > 34000
> > > > > > 
> > > > > > real	0m6.613s
> > > > > > user	0m0.000s
> > > > > > sys	0m0.001s
> > > > > > 
> > > > > 
> > > > > Is this a regression?  Was 2.6.29 OK?
> > > > > 
> > > > > Thanks.
> > > > 
> > > > My last kernel was fine:
> > > > 
> > > > $ time cat /sys/class/thermal/thermal_zone0/temp 
> > > > 48000
> > > > 
> > > > real	0m0.007s
> > > > user	0m0.001s
> > > > sys	0m0.007s
> > > > 
> > > > 
> > > > I also forgot to add some information about my kernels...
> > > > 
> > > > The good one is 2.6.29 + tuxonice as it was the day after the
> > > > 2.6.29 kernel was released.
> > > > 
> > > > The bad one is a pull from linus tree on april the 9th plus
> > > > tuxonice on the same day
> > > > 
> > > > from git (hope this helps):
> > > > $ git describe v2.6.29-tiago2-ice
> > > > v2.6.29-836-g00492ed
> > > > $ git describe v2.6.30-rc1-tiago1-ice
> > > > v2.6.30-rc1-1002-gac91f91
> > > > 
> > > > 
> > > > If tuxonice is a suspect, I will be glad to remove it and
> > > > recompile. If I have the time later this weekend, and nothing was
> > > > found, I will try to bisect this.
> > > > 
> > > 
> > > Here are some results from the bisect:
> > > The metric I used to mark a revision as good/bad was
> > > $ time for ((i =0; i < 100; i++)); do
> > >       cat /sys/class/thermal/thermal_zone0/temp > /dev/null; 
> > >   done
> > > 
> > > The bad ones take forever, i never even finished one bad run. The
> > > good ones take about half a second.
> > > 
> > > When I checked out revisions v2.6.29-148-g33526a5 and
> > > v2.6.29-159-g8a3f257, it took almost 2 secons to run the command,
> > > so I think some of the latency my have been introduced around
> > > these. Yet, I still marked them as good.
> > > 
> > > The resut was:
> > > 478c6a43fcbc6c11609f8cee7c7b57223907754f is first bad commit
> > > witch is a merge. I am out of ideas...
> > > 
> > > I forgot to ask, am I the only one experiencing this? I am using a
> > > TravelMate 4000 with the intel graphics chip, can anyone reproduce
> > > this? If no one can reproduce this, I can still test a vanilla
> > > kernel to remove TOI from the equation!
> > > 
> > > Tiago
> > > 
> > > 
> > > Below is the bisect log:
> > > $ git bisect log
> > > git bisect start
> > > # bad: [ac91f917d7ed7d1ebe14532ee137fcd759b4406d] Merge branch
> > > 'all' into all-tuxonice git bisect bad
> > > ac91f917d7ed7d1ebe14532ee137fcd759b4406d # good:
> > > [178a426510a901d9335f39d3391ae5e8628a36d1] Merge branch 'tuxonice'
> > > into all-tuxonice git bisect good
> > > 178a426510a901d9335f39d3391ae5e8628a36d1 # good:
> > > [fdf9c9979a355916433262ea5e5e64bed5def86e] V4L/DVB (10465):
> > > dsbr100: Add few lost mutex locks. git bisect good
> > > fdf9c9979a355916433262ea5e5e64bed5def86e # good:
> > > [edbd606c4671fcd439164c8d63e896044d706156] Staging: wlan-ng:
> > > Replace WLAN_LOG_ERROR() with printk() git bisect good
> > > edbd606c4671fcd439164c8d63e896044d706156 # good:
> > > [3516c6a8dc0b1153c611c4cf0dc4a51631f052bb] Merge
> > > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
> > > git bisect good 3516c6a8dc0b1153c611c4cf0dc4a51631f052bb # bad:
> > > [3989203290fba6fdf6bc4825fbf6526e1bf17977] Merge
> > > git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 git
> > > bisect bad 3989203290fba6fdf6bc4825fbf6526e1bf17977 # bad:
> > > [d7ca6f8cdffa5765e486edb3dada9121fba8e6aa] Merge branch 'for-linus'
> > > of git://git.o-hand.com/linux-rpurdie-backlight git bisect bad
> > > d7ca6f8cdffa5765e486edb3dada9121fba8e6aa # good:
> > > [3b4dadf05d177289c279c50030c7c75e004952bb] Merge branch
> > > 'acpi_enforce_resources' into release git bisect good
> > > 3b4dadf05d177289c279c50030c7c75e004952bb # bad:
> > > [32fb6c17566ec66de87324a834c7776f40e35e78] Merge branch 'release'
> > > of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
> > > git bisect bad 32fb6c17566ec66de87324a834c7776f40e35e78 # good:
> > > [45e36c1666aa6c8b0c538abcf984b336184d8c3f] Merge
> > > git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6 git
> > > bisect good 45e36c1666aa6c8b0c538abcf984b336184d8c3f # good:
> > > [33526a53600ac887d100e3c9b4be3637ac8ae3a5] Merge branch 'x2apic'
> > > into release git bisect good
> > > 33526a53600ac887d100e3c9b4be3637ac8ae3a5 # good:
> > > [c542aadeb4700bc316834d862d52ba3d2664f13a] panasonic-laptop: Fix
> > > autoloading git bisect good
> > > c542aadeb4700bc316834d862d52ba3d2664f13a # bad:
> > > [478c6a43fcbc6c11609f8cee7c7b57223907754f] Merge branch 'linus'
> > > into release git bisect bad
> > > 478c6a43fcbc6c11609f8cee7c7b57223907754f # good:
> > > [15065531c1c5902775ae3ade24eb37d0e688353b] toshiba-acpi: remove
> > > MAINTAINERS entry git bisect good
> > > 15065531c1c5902775ae3ade24eb37d0e688353b # good:
> > > [8a3f257c704e02aee9869decd069a806b45be3f1] Merge branch 'misc' into
> > > release git bisect good 8a3f257c704e02aee9869decd069a806b45be3f1
> > 
> 

