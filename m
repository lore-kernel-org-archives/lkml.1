Return-Path: <linux-kernel-owner+w=401wt.eu-S933789AbXEGNNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789AbXEGNNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933781AbXEGNNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:13:17 -0400
Received: from mxfep04.bredband.com ([195.54.107.79]:34580 "EHLO
	mxfep04.bredband.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933789AbXEGNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:13:16 -0400
Date: Mon, 7 May 2007 14:07:47 +0200
From: Mats Johannesson <spamcan@bredband.net>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64 highres/dyntick support
Message-ID: <20070507140747.2c68d7c9@loke.fish.not>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.4.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 06 2007 - Europe Evening Time Thomas Gleixner wrote:

> I'm pleased to announce the first cut of the final x86_64
> highres/dyntick support, which I did based on Chris Wright's patch
> set, which is again based on Arjan van de Ven's initial work:
[...]
> Comments, bugreports, patches are welcome as ususal

Are questions welcome? Then I'd ask: "What are the _minimal_ CPU
requirements to gain anything (eg less power consumption) with
dyntick?"

I ask because of a trial round with Chris Wright's patch set on a
fresh battery, idle system outside X with wifi card shut off and HZ
set to 100 (from my normal 1000):

root@sleipner:~# ls -l battest-the-new-battery/*
battest-the-new-battery/dyn-100hz-2.6.21:
total 4
-rw-r--r-- 1 root root  0 2007-04-27 00:50 start
-rw-r--r-- 1 root root  0 2007-04-27 03:54 stop
-rwxr-xr-x 1 root root 72 2007-04-26 22:16 test-batt.bash

battest-the-new-battery/plain-2.6.21:
total 4
-rw-r--r-- 1 root root  0 2007-04-27 13:16 start
-rw-r--r-- 1 root root  0 2007-04-27 16:22 stop
-rwxr-xr-x 1 root root 72 2007-04-26 22:16 test-batt.bash
root@sleipner:~#

The script just touched the "stop" file with a 2 minutes interval until
the machine died. As seen by the plus/minus 2 minutes results there is
absolutely no difference.

This AMD 64 Mobile processor only has a C1 level which isn't used:

root@sleipner:~# cat /proc/acpi/processor/CPU0/power
active state:            C1
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:
   *C1:                  type[C1] promotion[--] demotion[--]
latency[000] usage[00000000] duration[00000000000000000000]

But shouldn't the the kernel 'hlt' routine, or whatever it's called,
work in conjunction with dyntick to achieve... something...?

CPU markings are:

Mobile AMD Athlon 64
AMA3400BEX5AR 1169004L40404
CAAZC 0451APMW 2001 AMD
Assembled in Malaysia

root@sleipner:~# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 4
model name      : AMD Athlon(tm) 64 Processor 3400+
stepping        : 10
cpu MHz         : 800.000
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm
3dnowext 3dnow
bogomips        : 1601.73
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

Mvh,
Mats
