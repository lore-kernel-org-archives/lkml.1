Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYBEKQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYBEKQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYBEKQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:16:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754747AbYBEKQl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:16:41 -0500
Date: Tue, 5 Feb 2008 02:16:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Toralf =?ISO-8859-1?B?RvZyc3Rlcg==?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: Why do I have a /sys/devices/system/cpu/cpuidle under kernel
 2.6.24 with a Pentium M processor ?
Message-Id: <20080205021654.37286791.akpm@linux-foundation.org>
In-Reply-To: <200801311400.17811.toralf.foerster@gmx.de>
References: <200801311400.17811.toralf.foerster@gmx.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 14:00:14 +0100 Toralf Förster <toralf.foerster@gmx.de> wrote:

(suitable cc's added)

> I'm asking b/c this confuses the current sysstat up to version 8.0.4. An

That would be bad.  Please define "confuses"?

> $ ls -lR /sys/devices/system/cpu/
> 
> gives :
> 
> /sys/devices/system/cpu/:
> total 0
> drwxr-xr-x 4 root root 0 Jan 30 09:36 cpu0
> drwxr-xr-x 2 root root 0 Jan 30 09:36 cpuidle
> 
> /sys/devices/system/cpu/cpu0:
> total 0
> drwxr-xr-x 3 root root 0 Jan 30 09:36 cpufreq
> drwxr-xr-x 5 root root 0 Jan 30 09:36 cpuidle
> 
> /sys/devices/system/cpu/cpu0/cpufreq:
> total 0
> -r--r--r-- 1 root root 4096 Jan 30 09:36 affected_cpus
> -r-------- 1 root root 4096 Jan 30 09:36 cpuinfo_cur_freq
> -r--r--r-- 1 root root 4096 Jan 30 09:36 cpuinfo_max_freq
> -r--r--r-- 1 root root 4096 Jan 30 09:36 cpuinfo_min_freq
> drwxr-xr-x 2 root root    0 Jan 30 09:36 ondemand
> -r--r--r-- 1 root root 4096 Jan 30 09:36 scaling_available_frequencies
> -r--r--r-- 1 root root 4096 Jan 30 09:36 scaling_available_governors
> -r--r--r-- 1 root root 4096 Jan 30 09:36 scaling_cur_freq
> -r--r--r-- 1 root root 4096 Jan 30 09:36 scaling_driver
> -rw-r--r-- 1 root root 4096 Jan 30 09:36 scaling_governor
> -rw-r--r-- 1 root root 4096 Jan 30 09:36 scaling_max_freq
> -rw-r--r-- 1 root root 4096 Jan 30 09:36 scaling_min_freq
> 
> /sys/devices/system/cpu/cpu0/cpufreq/ondemand:
> total 0
> -rw-r--r-- 1 root root    0 Jan 30 09:36 ignore_nice_load
> -rw-r--r-- 1 root root 4096 Jan 30 09:36 powersave_bias
> -rw-r--r-- 1 root root 4096 Jan 30 09:36 sampling_rate
> -r--r--r-- 1 root root 4096 Jan 30 09:36 sampling_rate_max
> -r--r--r-- 1 root root 4096 Jan 30 09:36 sampling_rate_min
> -rw-r--r-- 1 root root 4096 Jan 30 09:36 up_threshold
> 
> /sys/devices/system/cpu/cpu0/cpuidle:
> total 0
> drwxr-xr-x 2 root root 0 Jan 30 09:36 state0
> drwxr-xr-x 2 root root 0 Jan 30 09:36 state1
> drwxr-xr-x 2 root root 0 Jan 30 09:36 state2
> 
> /sys/devices/system/cpu/cpu0/cpuidle/state0:
> total 0
> -r--r--r-- 1 root root 4096 Jan 30 09:36 latency
> -r--r--r-- 1 root root 4096 Jan 30 09:36 name
> -r--r--r-- 1 root root 4096 Jan 30 09:36 power
> -r--r--r-- 1 root root 4096 Jan 30 09:36 time
> -r--r--r-- 1 root root 4096 Jan 30 09:36 usage
> 
> /sys/devices/system/cpu/cpu0/cpuidle/state1:
> total 0
> -r--r--r-- 1 root root 4096 Jan 30 09:36 latency
> -r--r--r-- 1 root root 4096 Jan 30 09:36 name
> -r--r--r-- 1 root root 4096 Jan 30 09:36 power
> -r--r--r-- 1 root root 4096 Jan 30 09:36 time
> -r--r--r-- 1 root root 4096 Jan 30 09:36 usage
> 
> /sys/devices/system/cpu/cpu0/cpuidle/state2:
> total 0
> -r--r--r-- 1 root root 4096 Jan 30 09:36 latency
> -r--r--r-- 1 root root 4096 Jan 30 09:36 name
> -r--r--r-- 1 root root 4096 Jan 30 09:36 power
> -r--r--r-- 1 root root 4096 Jan 30 09:36 time
> -r--r--r-- 1 root root 4096 Jan 30 09:36 usage
> 
> /sys/devices/system/cpu/cpuidle:
> total 0
> -r--r--r-- 1 root root 4096 Jan 30 09:36 current_driver
> -r--r--r-- 1 root root 4096 Jan 30 09:36 current_governor_ro
> 
> -- 
> MfG/Sincerely
> 
> Toralf Förster
> pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
> 
