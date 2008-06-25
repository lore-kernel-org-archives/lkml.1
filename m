Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYFYHD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYFYHD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFYHDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:03:21 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:47801 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbYFYHDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:03:20 -0400
Date: Wed, 25 Jun 2008 04:03:19 -0300
From: Gustavo Fernando Padovan <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
Subject: [PATCH] x86: remove unnecessary #ifdef CONFIG_X86_32...#else
Message-ID: <20080625070319.GA15059@quasar.las>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the #ifdef conditional because this comparison is already done in
user_mode_vm().

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>


diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -55,11 +55,7 @@ static inline int notify_page_fault(struct pt_regs *regs)
 	int ret = 0;
 
 	/* kprobe_running() needs smp_processor_id() */
-#ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
-#else
-	if (!user_mode(regs)) {
-#endif
 		preempt_disable();
 		if (kprobe_running() && kprobe_fault_handler(regs, 14))
 			ret = 1;
