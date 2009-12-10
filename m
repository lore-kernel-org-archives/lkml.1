Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbZLJP4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbZLJP4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZLJP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:56:03 -0500
Received: from mail-ausfall.charite.de ([193.175.72.31]:35166 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZLJP4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:56:01 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2009 10:56:01 EST
Date: Thu, 10 Dec 2009 16:48:37 +0100
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6.32] WARNING: at arch/x86/kernel/apic/apic.c:249
 native_apic_write_dummy+0x30/0x3c()
Message-ID: <20091210154837.GT30903@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a vanilla 2.6.32 as Xen DomU, I'm getting:

[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] Performance Events: AMD PMU driver.
[    0.000999] ------------[ cut here ]------------
[    0.000999] WARNING: at arch/x86/kernel/apic/apic.c:249 native_apic_write_dummy+0x30/0x3c()
[    0.000999] Modules linked in:
[    0.000999] Pid: 0, comm: swapper Not tainted 2.6.32 #3
[    0.000999] Call Trace:
[    0.000999]  [<ffffffff8102611a>] ? native_apic_write_dummy+0x30/0x3c
[    0.000999]  [<ffffffff8104c5a2>] warn_slowpath_common+0x77/0x8f
[    0.000999]  [<ffffffff8104c5c9>] warn_slowpath_null+0xf/0x11
[    0.000999]  [<ffffffff8102611a>] native_apic_write_dummy+0x30/0x3c
[    0.000999]  [<ffffffff8101bf49>] perf_events_lapic_init+0x2e/0x30
[    0.000999]  [<ffffffff818cc6fe>] init_hw_perf_events+0x300/0x39d
[    0.000999]  [<ffffffff818cc25a>] identify_boot_cpu+0x3c/0x3e
[    0.000999]  [<ffffffff818cc3da>] check_bugs+0x9/0x2d
[    0.000999]  [<ffffffff818c4cae>] start_kernel+0x37a/0x38f
[    0.000999]  [<ffffffff818c42c1>] x86_64_start_reservations+0xac/0xb0
[    0.000999]  [<ffffffff818c7b79>] xen_start_kernel+0x530/0x534
[    0.000999] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000999] ... version:                0
[    0.000999] ... bit width:              48
[    0.000999] ... generic registers:      4
[    0.000999] ... value mask:             0000ffffffffffff
[    0.000999] ... max period:             00007fffffffffff
[    0.000999] ... fixed-purpose events:   0
[    0.000999] ... event mask:             000000000000000f
[    0.000999] SMP alternatives: switching to UP code

# uname -a
Linux fatush.arschkrebs.de 2.6.32 #3 SMP Tue Dec 8 22:09:42 CET 2009 x86_64 GNU/Linux

# cat /proc/cpuinfo 
processor	    : 0
vendor_id	    : AuthenticAMD
cpu family	    : 15
model		    : 67
model name	    : AMD Athlon(tm) 64 X2 Dual Core Processor 5600+
stepping	    : 3
cpu MHz	            : 2799.966
cache size	    : 1024 KB
fpu   		    : yes
fpu_exception	    : yes
cpuid level	    : 1
wp    		    : yes
flags		    : fpu de tsc msr pae cx8 cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 3dnowext 3dnow up rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips : 5599.93
TLB size : 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

-- 
Ralf Hildebrandt
  Geschäftsbereich IT | Abteilung Netzwerk
  Charité - Universitätsmedizin Berlin
  Campus Benjamin Franklin
  Hindenburgdamm 30 | D-12203 Berlin
  Tel. +49 30 450 570 155 | Fax: +49 30 450 570 962
  ralf.hildebrandt@charite.de | http://www.charite.de
	    
