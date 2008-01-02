Return-Path: <linux-kernel-owner+w=401wt.eu-S1760332AbYABXaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760332AbYABXaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759760AbYABXYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:24:38 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14431 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759749AbYABXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:24:36 -0500
Message-ID: <477C1D26.4070200@ct.jp.nec.com>
Date: Wed, 02 Jan 2008 15:24:22 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: clean up apic_32/64.c
References: <477BD875.2090508@ct.jp.nec.com> <20080102195425.GA31700@elte.hu>
In-Reply-To: <20080102195425.GA31700@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> 
>> White space and coding style clean up. Make apic_32/64.c similar.
> 
> thanks, applied. FYI, there's still a bit left in apic_32.c:
> 
>  total: 5 errors, 1 warnings, 1566 lines checked
> 
> we might as well go for all of them? :-)

thanks, I made a clean up patch for it.

total: 0 errors, 0 warnings, 1567 lines checked

---
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH] x86: clean up apic_32.c

White space and coding style clean up.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/apic_32.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 1e417df..3defb3c 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -46,7 +46,7 @@
 /*
  * Sanity check
  */
-#if (SPURIOUS_APIC_VECTOR & 0x0F) != 0x0F
+#if ((SPURIOUS_APIC_VECTOR & 0x0F) != 0x0F)
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
@@ -55,7 +55,7 @@
  *
  * -1=force-disable, +1=force-enable
  */
-static int enable_local_apic __initdata = 0;
+static int enable_local_apic __initdata;
 
 /* Local APIC timer verification ok */
 static int local_apic_timer_verify_ok;
@@ -432,7 +432,7 @@ void __init setup_boot_APIC_clock(void)
 			       "with PM Timer: %ldms instead of 100ms\n",
 			       (long)res);
 			/* Correct the lapic counter value */
-			res = (((u64) delta ) * pm_100ms);
+			res = (((u64) delta) * pm_100ms);
 			do_div(res, deltapm);
 			printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
 			       "%lu (%ld)\n", (unsigned long) res, delta);
@@ -976,7 +976,8 @@ void __cpuinit setup_local_APIC(void)
 		value |= APIC_LVT_LEVEL_TRIGGER;
 	apic_write_around(APIC_LVT1, value);
 
-	if (integrated && !esr_disable) {		/* !82489DX */
+	if (integrated && !esr_disable) {
+		/* !82489DX */
 		maxlvt = lapic_get_maxlvt();
 		if (maxlvt > 3)		/* Due to the Pentium erratum 3AP. */
 			apic_write(APIC_ESR, 0);
@@ -1262,7 +1263,7 @@ void smp_error_interrupt(struct pt_regs *regs)
 	   6: Received illegal vector
 	   7: Illegal register address
 	*/
-	printk (KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
+	printk(KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
 		smp_processor_id(), v , v1);
 	irq_exit();
 }
@@ -1349,7 +1350,7 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 			value = apic_read(APIC_LVT0);
 			value &= ~(APIC_MODE_MASK | APIC_SEND_PENDING |
 				APIC_INPUT_POLARITY | APIC_LVT_REMOTE_IRR |
-				APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED );
+				APIC_LVT_LEVEL_TRIGGER | APIC_LVT_MASKED);
 			value |= APIC_LVT_REMOTE_IRR | APIC_SEND_PENDING;
 			value = SET_APIC_DELIVERY_MODE(value, APIC_MODE_EXTINT);
 			apic_write_around(APIC_LVT0, value);
-- 
1.5.3.6

