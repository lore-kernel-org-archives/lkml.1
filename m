Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYLOR7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYLOR7d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 12:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYLOR7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 12:59:24 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:59151 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYLOR7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 12:59:23 -0500
Date: Mon, 15 Dec 2008 12:59:15 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: Perfomance governor is still changing frequency
In-reply-to: <c4e36d110812150515q1c4b2458wa61c79c5a85c624e@mail.gmail.com>
X-X-Sender: lenb@localhost.localdomain
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org
Message-id: <alpine.LFD.2.00.0812151242430.16823@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <c4e36d110812150515q1c4b2458wa61c79c5a85c624e@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Dec 2008, Zdenek Kabelac wrote:

> Hi
> 
> I'm noticing strange behavior on my T61.
> 
> When I select performance governor  for my CPU I still get occasional
> drop on CPU frequency from 2.2.GHz to 800MHz.
> 
> I'm attaching my .config file.
> 
> How it could happen that perfomance is actually able to change
> frequency from it's highest mode - is it because of some overheating ?

performance governor itself will not change the frequency.

> (It usually happens when I run   make -j2 -  even just for a minute -
> it suddenly start to drop the CPU to lowest clock rate -
> imho I think the machine is quite calm to be 'overheated')
> 
> What other debug info is needed ?
> 
> 
> affected_cpus
> 0 1
> cpuinfo_cur_freq
> 2201000
> cpuinfo_max_freq
> 2201000
> cpuinfo_min_freq
> 800000
> related_cpus
> 0 1
> scaling_available_frequencies
> 2201000 2200000 1600000 1200000 800000
> scaling_available_governors
> ondemand performance
> scaling_cur_freq
> 2201000
> scaling_driver
> acpi-cpufreq
> scaling_governor
> performance
> scaling_max_freq
> 2201000
> scaling_min_freq
> 800000
> scaling_setspeed
> <unsupported>
> 
> 
>  stats/time_in_state
> 2201000 331831
> 2200000 2876
> 1600000 1739
> 1200000 3398
> 800000 512768
> 
> 
> (btw why do I have two states  - 2201000 and 2200000 ??)


2201000 is the marketing speed of your processor, plus 1MHz.
This is used by the ACPI BIOS to enable "Turbo Mode",
aka Intel Dynamic Acceleration Technology --
which gives the harware license to run faster than
2.2GHz if the conditions are right.
ie. when there is still no idle time available at 2.2GHz,
ondemand chooses 2.21 Ghz, and the HW may give it more...

The right conditions depend on the part -- could be that
some cores need to be in deep idle to let other cores
go fast, or it could be based on current and thermal
constraints, or both.

I have a 2.0 GHz T61, and I'm unable to reproduce
your observation.

You can eliminate turbo from the picture by
echo 2200000 > time_in_state

and that will tell us if turbo is related to your
occasional obervance of low-frequency-mode.

You can also observe the temperature in
/proc/acpi/thermal*/*/temperature

cheers,
-Len

