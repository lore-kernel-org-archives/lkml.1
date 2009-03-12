Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbZCLM4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbZCLM4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZCLM4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:56:34 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38276 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbZCLM4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:56:33 -0400
Message-Id: <49B914B6.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 12:57:10 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: clean up output resulting from update_mptable
	 option
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Without apic=verbose, using the update_mptable option would result in
garbled and confusing output due to the inconsistent use of printk() vs
apic_printk().

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/mpparse.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.29-rc7/arch/x86/kernel/mpparse.c	2009-03-04 09:10:19.000000000 +0100
+++ 2.6.29-rc7-x86-update-mptable/arch/x86/kernel/mpparse.c	2009-03-06 11:07:34.000000000 +0100
@@ -876,12 +876,12 @@ static int  __init replace_intsrc_all(st
 #ifdef CONFIG_X86_IO_APIC
 				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 
-				printk(KERN_INFO "OLD ");
+				apic_printk(APIC_VERBOSE, "OLD ");
 				print_MP_intsrc_info(m);
 				i = get_MP_intsrc_index(m);
 				if (i > 0) {
 					assign_to_mpc_intsrc(&mp_irqs[i], m);
-					printk(KERN_INFO "NEW ");
+					apic_printk(APIC_VERBOSE, "NEW ");
 					print_mp_irq_info(&mp_irqs[i]);
 				} else if (!i) {
 					/* legacy, do nothing */
@@ -929,7 +929,7 @@ static int  __init replace_intsrc_all(st
 			continue;
 
 		if (nr_m_spare > 0) {
-			printk(KERN_INFO "*NEW* found ");
+			apic_printk(APIC_VERBOSE, "*NEW* found\n");
 			nr_m_spare--;
 			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
 			m_spare[nr_m_spare] = NULL;



