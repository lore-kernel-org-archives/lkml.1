Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbZCMCgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbZCMCgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZCMCe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:34:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:52470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbZCMCev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:34:51 -0400
Date: Fri, 13 Mar 2009 02:34:11 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B914B6.76E4.0078.0@novell.com>
References: <49B914B6.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86: clean up output resulting from update_mptable option
Message-ID: <tip-82034d6f59b4772f4233bbb61c670290803a9960@git.kernel.org>
Git-Commit-ID: 82034d6f59b4772f4233bbb61c670290803a9960
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:34:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82034d6f59b4772f4233bbb61c670290803a9960
Gitweb:     http://git.kernel.org/tip/82034d6f59b4772f4233bbb61c670290803a9960
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:57:10 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:19 +0100

x86: clean up output resulting from update_mptable option

Impact: cleanup

Without apic=verbose, using the update_mptable option would result in
garbled and confusing output due to the inconsistent use of printk() vs
apic_printk().

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B914B6.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/mpparse.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index e819240..47673e0 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -890,12 +890,12 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
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
@@ -943,7 +943,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			continue;
 
 		if (nr_m_spare > 0) {
-			printk(KERN_INFO "*NEW* found ");
+			apic_printk(APIC_VERBOSE, "*NEW* found\n");
 			nr_m_spare--;
 			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
 			m_spare[nr_m_spare] = NULL;
