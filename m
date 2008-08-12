Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbYHLHaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbYHLHaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYHLHaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:30:00 -0400
Received: from qmta10.westchester.pa.mail.comcast.net ([76.96.62.17]:37441
	"EHLO QMTA10.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbYHLH37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:29:59 -0400
X-Authority-Analysis: v=1.0 c=1 a=o6SizqMz_CkA:10 a=6LLILg6-L-YA:10
 a=rITDv7nW5hcA:10 a=dlLkqa3d77d3BijdyVcA:9 a=T7Nr2E_OBGpdK9cbIJx_0cGPWy8A:4
 a=3SmO1NJXDBsA:10
Message-ID: <48A13BF4.3090500@comcast.net>
Date: Tue, 12 Aug 2008 00:29:56 -0700
From: Eric Benton <erbenton@comcast.net>
Reply-To: erbenton@comcast.net
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Fwd: how to add support in coretemp.c for Q9450 processor]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
To add coretemp (thermal monitoring) support for the Intel Q9450 
processor add the code below. i have tested this on several kernels 
including 2.6.26 and it works fine.  the code addition is 
*||(c->x86_model == 0x17) in the if statement*
Thanks
Eric

*in:*
drivers/hwmon/coretemp.c
*in function:*
static int __init coretemp_init(void)

*change:*
 if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
                    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
                        (c->x86_model == 0x16))) {

                        /* supported CPU not found, but report the unknown
                           family 6 CPU */
                        if ((c->x86 == 0x6) && (c->x86_model > 0xf))
                                printk(KERN_WARNING DRVNAME ": Unknown CPU "
                                        "model %x\n", c->x86_model);
                        continue;
                }
*to*
 if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
                    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
                        (c->x86_model == 0x16)*||(c->x86_model == 0x17)*)) {

                        /* supported CPU not found, but report the unknown
                           family 6 CPU */
                        if ((c->x86 == 0x6) && (c->x86_model > 0xf))
                                printk(KERN_WARNING DRVNAME ": Unknown CPU "
                                        "model %x\n", c->x86_model);
                        continue;
                }
----------------------------------------------------------
*Info:*
# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : *23*
model name      : Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz
stepping        : 7
cpu MHz         : 1998.000
cache size      : 6144 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good pni monitor 
ds_cpl vmx smx est tm2 ssse3 cx16 xtpr sse4_1 lahf_lm
bogomips        : 5319.97
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

