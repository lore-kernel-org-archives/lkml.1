Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbYFGCqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbYFGCqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 22:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYFGCqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 22:46:21 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:60969 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbYFGCqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 22:46:20 -0400
Date: Fri, 06 Jun 2008 22:46:17 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: bug? acpi p-state + ondemand keeps dropping max freq
In-reply-to: <48486920.4040006@intel.com>
X-X-Sender: lenb@localhost.localdomain
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       "Brown, Len" <len.brown@intel.com>, cpufreq@lists.linux.org.uk
Message-id: <alpine.LFD.1.10.0806062240410.3110@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <48486920.4040006@intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jun 2008, Kok, Auke wrote:

> 
> I've consistently experienced the following bizarre problem since 2.6.20, all the
> way up to 2.6.25.3 (regressed yesterday and each of these kernels exposes this
> behaviour):
> 
> /sys/devices/system/cpu/cpu0/cpufreq # grep . *
> affected_cpus:0
> cpuinfo_cur_freq:800000
> cpuinfo_max_freq:1866000
> cpuinfo_min_freq:800000
> scaling_available_frequencies:1866000 1600000 1333000 1066000 800000
> scaling_available_governors:ondemand performance
> scaling_cur_freq:800000
> scaling_driver:acpi-cpufreq
> scaling_governor:ondemand
> scaling_max_freq:800000
> scaling_min_freq:800000
> 
> 
> 
> Notice that scaling_mx_freq dropped down to the lowest possible value and as such
> my CPU is only working at 800MHz. At boot time this field properly displays
> 1866MHz and everything works OK. After a certain period (?) this value drops down
> and I cannot manually elevate it back to the normal level:
> 
> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> 800000
> # echo 1866000 > scaling_max_freq ; cat scaling_max_freq
> 800000
> 
> 
> This renders my Dothan to utterly poor speeds. (standard T43)
> 
> performance cpufreq governor makes no difference - I still can't change the
> frequency upper/lower values.

could be two causes:
1. thermal
2. user space

for #1....

watch grep . /proc/acpi/thermal_zone/THM*/*
and see if anythign is climbing
you can build w/o CONFIG_ACPI_THERMAL
and see if they symptom goes away -- for that
is the module which would force cpufreq to Pn.


for #2...

see if it happens in single user mode without
hal or distro daemons running.

cheers,
-Len

