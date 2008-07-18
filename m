Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbYGRMcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbYGRMcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYGRMcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:32:03 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:30295 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395AbYGRMcC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:32:02 -0400
Message-Id: <4880A977.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 18 Jul 2008 13:32:23 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386/xen: add proper unwind annotations to
	xen_sysenter_target
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

---
 arch/x86/kernel/entry_32.S |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.26/arch/x86/kernel/entry_32.S	2008-07-13 23:51:29.000000000 +0200
+++ 2.6.26-i386-xen-entry-annot/arch/x86/kernel/entry_32.S	2008-07-15 14:51:28.000000000 +0200
@@ -1023,7 +1023,9 @@ ENDPROC(kernel_thread_helper)
 ENTRY(xen_sysenter_target)
 	RING0_INT_FRAME
 	addl $5*4, %esp		/* remove xen-provided frame */
+	CFI_ADJUST_CFA_OFFSET -5*4
 	jmp sysenter_past_esp
+	CFI_ENDPROC
 
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC



