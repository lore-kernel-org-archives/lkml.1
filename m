Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZAFBJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZAFBJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 20:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZAFBJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 20:09:47 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53631 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751126AbZAFBJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 20:09:46 -0500
Message-ID: <4962AF55.9060704@sgi.com>
Date: Mon, 05 Jan 2009 17:09:41 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <Yinghai.Lu@Sun.COM>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix x86_32 builds for summit and es7000 arch's
References: <49629225.1030104@sun.com> <4962A756.2070507@sgi.com>
In-Reply-To: <4962A756.2070507@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Yinghai Lu wrote:
>> In file included from arch/x86/mach-generic/summit.c:16:
>> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:
>> In function Ã¢â‚¬Ëœcpu_mask_to_apicid_andÃ¢â‚¬â„¢:
>> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
>> error: Ã¢â‚¬ËœGFP_ATOMICÃ¢â‚¬â„¢ undeclared (first use in this function)
>> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
>> error: (Each undeclared identifier is reported only once
>> /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
>> error: for each function it appears in.)
>>
>> YH
>>
> 
> Hi Yinghai,
> 
> Thanks for catching this, I'm looking at it now.  We had a bit of a power
> problem here and have been down for a while.
> 
> Thanks,
> Mike

Subject: x86: fix x86_32 builds for summit and es7000 arch's

Impact: fix build errors on x86_32

Fix the following build errors reported by Yinghai Lu:

| In file included from arch/x86/mach-generic/summit.c:16:
| /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:
| In function Ã¢â?¬Ë?cpu_mask_to_apicid_andÃ¢â?¬â?¢:
| /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
| error: Ã¢â?¬Ë?GFP_ATOMICÃ¢â?¬â?¢ undeclared (first use in this function)
| /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
| error: (Each undeclared identifier is reported only once
| /home/yhlu/xx/xx/kernel/tip/linux-2.6/arch/x86/include/asm/summit/apic.h:179:
| error: for each function it appears in.)
| 
| YH

Note: tested build only.

Based on tip/cpus4096: v2.6.28-5703-g1d1a70e

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/es7000/apic.h |    2 ++
 arch/x86/include/asm/summit/apic.h |    1 +
 2 files changed, 3 insertions(+)

--- linux-2.6-for-ingo.orig/arch/x86/include/asm/es7000/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/es7000/apic.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_ES7000_APIC_H
 #define __ASM_ES7000_APIC_H
 
+#include <linux/gfp.h>
+
 #define xapic_phys_to_log_apicid(cpu) per_cpu(x86_bios_cpu_apicid, cpu)
 #define esr_disable (1)
 
--- linux-2.6-for-ingo.orig/arch/x86/include/asm/summit/apic.h
+++ linux-2.6-for-ingo/arch/x86/include/asm/summit/apic.h
@@ -2,6 +2,7 @@
 #define __ASM_SUMMIT_APIC_H
 
 #include <asm/smp.h>
+#include <linux/gfp.h>
 
 #define esr_disable (1)
 #define NO_BALANCE_IRQ (0)
