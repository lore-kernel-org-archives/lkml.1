Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYHHUDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYHHUDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYHHUDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:03:44 -0400
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:52021 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYHHUDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:03:43 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 16:03:43 EDT
From: "CIJOML" <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Subject: PATCH: enable PAT at Pentium M 1.7 GHz
Date: Fri, 08 Aug 2008 21:57:43 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <20080808195743.7EDAEB88F@nebuchadnezzar.smejdil.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there, 

Sending oneliner enabling PAT at my Pentium M 1.7 GHz CPU. It simply works.
Thanks for inclusion: 

 --- linux-2.6.26.2/arch/x86/kernel/cpu/addon_cpuid_features.c      
2008-08-08 21:52:20.000000000 +0200
+++ linux-2.6.26.2/arch/x86/kernel/cpu/addon_cpuid_features.c   2008-08-08 
21:41:17.000000000 +0200
@@ -59,7 +59,7 @@
                        return;
                break;
        case X86_VENDOR_INTEL:
 -               if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 15))
+               if (c->x86 == 0xF || (c->x86 == 6 && c->x86_model >= 13))
                        return;
                break;
        } 

Listik:/usr/src# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 13
model name      : Intel(R) Pentium(R) M processor 1.70GHz
stepping        : 6
cpu MHz         : 600.000
cache size      : 2048 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr mce cx8 apic sep mtrr pge mca cmov 
pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
bogomips        : 1200.47
clflush size    : 64
power management: 


before:
Aug  8 19:08:27 Listik kernel: PAT disabled. Not yet verified on this CPU 
type. 


after:
Aug  8 21:43:34 Listik kernel: x86 PAT enabled: cpu 0, old 0x7040600070406, 
new 0x7010600070106 

Bye 

Michal
