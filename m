Return-Path: <linux-kernel-owner+w=401wt.eu-S1030909AbXDNABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030909AbXDNABT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 20:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030905AbXDNABS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 20:01:18 -0400
Received: from smtp-out20.alice.it ([85.33.2.20]:4611 "EHLO
	smtp-out01.alice.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030906AbXDNABQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 20:01:16 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2007 20:01:15 EDT
Date: Sat, 14 Apr 2007 01:45:13 +0200
From: Mattia Dongili <malattia@linux.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Shaohua Li <shaohua.li@intel.com>
Subject: CPU_IDLE prevents resuming from STR [was: Re: 2.6.21-rc6-mm1]
Message-ID: <20070413234513.GA2940@inferi.kami.home>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.21-rc6-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 13 Apr 2007 23:45:11.0656 (UTC) FILETIME=[C6BDB680:01C77E25]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 02:35:59PM -0700, Andrew Morton wrote:
...
>  git-acpi.patch

after bisecting I can finally say what breaks resume from STR here:

tadaaaaa: CPU_IDLE.
I first spotted the git-acpi.patch then reapplied it and disabled
CPU_IDLE, now my laptop resumes.

Any useful information I should add?

$ cat /sys/devices/system/cpu/cpuidle/*
acpi_idle 
no governors
acpi_idle
no governor

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
stepping	: 6
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3671.24
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz
stepping	: 6
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 15805.85
clflush size	: 64

-- 
mattia
:wq!
