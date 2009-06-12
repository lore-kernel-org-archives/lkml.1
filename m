Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbZFLQuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbZFLQuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZFLQuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:50:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:47497 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFLQuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:50:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,210,1243839600"; 
   d="scan'208";a="698848307"
Subject: Re: [BUG][2.6.30] Niced processes do not raise CPU frequency with
 ondemand
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <200906121844.02004.elendil@planet.nl>
References: <200906121844.02004.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 09:48:37 -0700
Message-Id: <1244825317.4534.1342.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 09:44 -0700, Frans Pop wrote:
> I first noticed this while (cross-)compiling several 2.6.30 kernels on my 
> Core Duo HP 2510p notebook. I run the kernel builds with 'nice -n 10' and 
> noticed that both cores stayed at 800MHz instead of going up to 1333MHz.
> 
> It does not seem to be a cpufreq problem as the frequency does go up if I 
> run the process without nice.
> 
> I can simply reproduce it by running an empty loop:
> $ sh -c "while :; do :; done" => one core immediately goes to 1333MHz
> $ nice -n 10 sh -c "while :; do :; done" => both cores stay at 800MHz
> 
> In both cases top shows 99/100% CPU usage for one core.
> 
> The problem does not occur immediately after a new boot: the cpu frequency 
> does get raised to 1333MHz even for niced processes. I've also checked 
> that a single suspend to RAM + resume cycle does not trigger it.
> 
> It is possible that it is triggered by undocking the notebook (I have not 
> verified that yet), but I do know that the problem remains after the 
> notebook is docked again.
> 
> I'm certain that the problem did not occur with earlier kernels (even when 
> undocked), but am not sure when it first started happening. As I'm not 
> yet certain how to trigger it, I cannot currently check that.
> 
> System is running x86_64 kernel with Debian stable ("Lenny") userland.
> 
> Any suggestions?
> 
> Cheers,
> FJP
> 
> # grep . /sys/devices/system/cpu/*/cpufreq/*
> .../cpu0/cpufreq/affected_cpus:0
> .../cpu0/cpufreq/cpuinfo_cur_freq:800000
> .../cpu0/cpufreq/cpuinfo_max_freq:1333000
> .../cpu0/cpufreq/cpuinfo_min_freq:800000
> .../cpu0/cpufreq/cpuinfo_transition_latency:10000
> .../cpu0/cpufreq/related_cpus:0 1
> .../cpu0/cpufreq/scaling_available_frequencies:1333000 1200000 1067000 
> 933000 800000
> .../cpu0/cpufreq/scaling_available_governors:ondemand performance
> .../cpu0/cpufreq/scaling_cur_freq:800000
> .../cpu0/cpufreq/scaling_driver:acpi-cpufreq
> .../cpu0/cpufreq/scaling_governor:ondemand
> .../cpu0/cpufreq/scaling_max_freq:1333000
> .../cpu0/cpufreq/scaling_min_freq:800000
> .../cpu0/cpufreq/scaling_setspeed:<unsupported>
> .../cpu1/cpufreq/affected_cpus:1
> .../cpu1/cpufreq/cpuinfo_cur_freq:800000
> .../cpu1/cpufreq/cpuinfo_max_freq:1333000
> .../cpu1/cpufreq/cpuinfo_min_freq:800000
> .../cpu1/cpufreq/cpuinfo_transition_latency:10000
> .../cpu1/cpufreq/related_cpus:0 1
> .../cpu1/cpufreq/scaling_available_frequencies:1333000 1200000 1067000 
> 933000 800000
> .../cpu1/cpufreq/scaling_available_governors:ondemand performance
> .../cpu1/cpufreq/scaling_cur_freq:800000
> .../cpu1/cpufreq/scaling_driver:acpi-cpufreq
> .../cpu1/cpufreq/scaling_governor:ondemand
> .../cpu1/cpufreq/scaling_max_freq:1333000
> .../cpu1/cpufreq/scaling_min_freq:800000
> .../cpu1/cpufreq/scaling_setspeed:<unsupported>

What does ignore_nice under cpufreq/ondemand say?

# grep . /sys/devices/system/cpu/*/cpufreq/ondemand/*

Thanks,
Venki


