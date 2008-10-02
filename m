Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbYJBPL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbYJBPL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbYJBPLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:11:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbYJBPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:11:05 -0400
Message-Id: <20081002151104.251607876@goodmis.org>
References: <20081002150529.087488257@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 11:05:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/5] xen: clean up label
Content-Disposition: inline; filename=xen-clean-up-patch-site.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In enlighten.c there's a macro that is defined to jump to a label.
This macro is only used in an ifdef CONFIG_X86_32 section, and the
label is outside that define conditional, which causes warnings.

This patch pushes the label inside the define condition.

CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/xen/enlighten.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-compile.git/arch/x86/xen/enlighten.c
===================================================================
--- linux-compile.git.orig/arch/x86/xen/enlighten.c	2008-09-12 09:18:55.000000000 -0400
+++ linux-compile.git/arch/x86/xen/enlighten.c	2008-10-02 09:38:16.000000000 -0400
@@ -1082,10 +1082,10 @@ static unsigned xen_patch(u8 type, u16 c
 		SITE(pv_irq_ops, irq_disable);
 		SITE(pv_irq_ops, save_fl);
 		SITE(pv_irq_ops, restore_fl);
-#endif /* CONFIG_X86_32 */
-#undef SITE
 
 	patch_site:
+#endif /* CONFIG_X86_32 */
+#undef SITE
 		if (start == NULL || (end-start) > len)
 			goto default_patch;
 

-- 
