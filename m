Return-Path: <linux-kernel-owner+w=401wt.eu-S932390AbZFLQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbZFLQoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZFLQoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:44:03 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:61924 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696AbZFLQoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:44:02 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [BUG][2.6.30] Niced processes do not raise CPU frequency with ondemand
Date: Fri, 12 Jun 2009 18:44:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906121844.02004.elendil@planet.nl>
X-OriginalArrivalTime: 12 Jun 2009 16:44:02.0574 (UTC) FILETIME=[FDF20AE0:01C9EB7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I first noticed this while (cross-)compiling several 2.6.30 kernels on my 
Core Duo HP 2510p notebook. I run the kernel builds with 'nice -n 10' and 
noticed that both cores stayed at 800MHz instead of going up to 1333MHz.

It does not seem to be a cpufreq problem as the frequency does go up if I 
run the process without nice.

I can simply reproduce it by running an empty loop:
$ sh -c "while :; do :; done" => one core immediately goes to 1333MHz
$ nice -n 10 sh -c "while :; do :; done" => both cores stay at 800MHz

In both cases top shows 99/100% CPU usage for one core.

The problem does not occur immediately after a new boot: the cpu frequency 
does get raised to 1333MHz even for niced processes. I've also checked 
that a single suspend to RAM + resume cycle does not trigger it.

It is possible that it is triggered by undocking the notebook (I have not 
verified that yet), but I do know that the problem remains after the 
notebook is docked again.

I'm certain that the problem did not occur with earlier kernels (even when 
undocked), but am not sure when it first started happening. As I'm not 
yet certain how to trigger it, I cannot currently check that.

System is running x86_64 kernel with Debian stable ("Lenny") userland.

Any suggestions?

Cheers,
FJP

# grep . /sys/devices/system/cpu/*/cpufreq/*
.../cpu0/cpufreq/affected_cpus:0
.../cpu0/cpufreq/cpuinfo_cur_freq:800000
.../cpu0/cpufreq/cpuinfo_max_freq:1333000
.../cpu0/cpufreq/cpuinfo_min_freq:800000
.../cpu0/cpufreq/cpuinfo_transition_latency:10000
.../cpu0/cpufreq/related_cpus:0 1
.../cpu0/cpufreq/scaling_available_frequencies:1333000 1200000 1067000 
933000 800000
.../cpu0/cpufreq/scaling_available_governors:ondemand performance
.../cpu0/cpufreq/scaling_cur_freq:800000
.../cpu0/cpufreq/scaling_driver:acpi-cpufreq
.../cpu0/cpufreq/scaling_governor:ondemand
.../cpu0/cpufreq/scaling_max_freq:1333000
.../cpu0/cpufreq/scaling_min_freq:800000
.../cpu0/cpufreq/scaling_setspeed:<unsupported>
.../cpu1/cpufreq/affected_cpus:1
.../cpu1/cpufreq/cpuinfo_cur_freq:800000
.../cpu1/cpufreq/cpuinfo_max_freq:1333000
.../cpu1/cpufreq/cpuinfo_min_freq:800000
.../cpu1/cpufreq/cpuinfo_transition_latency:10000
.../cpu1/cpufreq/related_cpus:0 1
.../cpu1/cpufreq/scaling_available_frequencies:1333000 1200000 1067000 
933000 800000
.../cpu1/cpufreq/scaling_available_governors:ondemand performance
.../cpu1/cpufreq/scaling_cur_freq:800000
.../cpu1/cpufreq/scaling_driver:acpi-cpufreq
.../cpu1/cpufreq/scaling_governor:ondemand
.../cpu1/cpufreq/scaling_max_freq:1333000
.../cpu1/cpufreq/scaling_min_freq:800000
.../cpu1/cpufreq/scaling_setspeed:<unsupported>
