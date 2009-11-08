Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZKHOv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZKHOv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZKHOv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:51:59 -0500
Received: from lucidpixels.com ([75.144.35.66]:50480 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZKHOv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:51:58 -0500
Date: Sun, 8 Nov 2009 09:52:03 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31.4+Benchmarks: Core i5/7 - No turbo boost, maximum speed is
 always 2.93 GHz?
Message-ID: <alpine.DEB.2.00.0911080943400.4571@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It looks like turbo boost is never activated...

[   23.322132] freq-table: target is 0 (2927000 kHz, 0)
[   23.322133] cpufreq-core: governor: change or update limits
[   23.322135] cpufreq-core: __cpufreq_governor for CPU 7, event 3
[   23.322137] cpufreq-core: target for CPU 7: 2927000 kHz, relation 1
[   23.322138] freq-table: request for target 2927000 kHz (relation: 1) for cpu 7
[   23.322140] freq-table: target is 0 (2927000 kHz, 0)

I tried setting it manually as well:

cpufreq-set -g ondemand -d 1100000 -u 3600000

# cat /sys/devices/system/cpu/cpu*/cpufreq/*max*
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000
2927000

--

Using the latest Intel BIOS on a DP55KG, I have run multiple tests and all
seem to be within the noise:

Q6600:
71.37user 0.56system 1:11.97elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2002minor)pagefaults 0swaps

i870:
- SpeedStep Tech: ON
- C States: ON
50.14user 0.11system 0:50.27elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2022minor)pagefaults 0swaps
50.14user 0.11system 0:50.27elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2653minor)pagefaults 0swaps

- SpeedStep Tech: OFF
- C States: ON
49.63user 0.13system 0:49.81elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2021minor)pagefaults 0swaps
49.95user 0.07system 0:50.03elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2022minor)pagefaults 0swaps

- SpeedStep Tech: OFF
- C States: OFF
49.62user 0.11system 0:49.79elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2021minor)pagefaults 0swaps
50.12user 0.07system 0:50.20elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2022minor)pagefaults 0swaps

- SpeedStep Tech: ON
- C States: ON
- ACPI_FREQ/KERNEL OPTIONS COMPILED IN - Set to: PERFORMANCE

44.50user 0.12system 0:44.69elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (1major+2022minor)pagefaults 0swaps
47.13user 0.09system 0:47.27elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
0inputs+0outputs (0major+2023minor)pagefaults 0swaps

Still though, something does not seem right, 2.93 GHz -- if the CPU speed
was really increasing to 3.60 GHz this would be much faster?

File: linux-2.6.31.tar
Benchmark: /usr/bin/time bzip2 -c -9 *tar > /dev/null
