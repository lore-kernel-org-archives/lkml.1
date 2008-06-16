Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbYFPNYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbYFPNYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbYFPNXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:23:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667AbYFPNXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:23:39 -0400
To: torvalds@linux-foundation.org
Cc: jacmet@sunsite.dk, dhowells@redhat.com, k.shutemov@gmail.com,
       linux-kernel@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Date: Mon, 16 Jun 2008 12:18:24 +0100
In-Reply-To: <87abhl7eqo.fsf@macbook.be.48ers.dk>
Subject: [PATCH 3/4] Remove #ifdef CONFIG_ARCH_SUPPORTS_AOUT from <linux/a.out.h>
Message-Id: <E1K8Efv-0002HG-S5@pmac.infradead.org>
X-Bad-Reply: In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is only included where it makes sense now, so there's no need
for the CONFIG_ARCH_SUPPORTS_AOUT conditional -- and that conditional is
bad, because we want to export <linux/a.out.h> to userspace.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 include/linux/a.out.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/include/linux/a.out.h b/include/linux/a.out.h
index 208f4e8..e86dfca 100644
--- a/include/linux/a.out.h
+++ b/include/linux/a.out.h
@@ -1,8 +1,6 @@
 #ifndef __A_OUT_GNU_H__
 #define __A_OUT_GNU_H__
 
-#ifdef CONFIG_ARCH_SUPPORTS_AOUT
-
 #define __GNU_EXEC_MACROS__
 
 #ifndef __STRUCT_EXEC_OVERRIDE__
@@ -277,10 +275,4 @@ struct relocation_info
 #endif /* no N_RELOCATION_INFO_DECLARED.  */
 
 #endif /*__ASSEMBLY__ */
-#else /* CONFIG_ARCH_SUPPORTS_AOUT */
-#ifndef __ASSEMBLY__
-struct exec {
-};
-#endif
-#endif /* CONFIG_ARCH_SUPPORTS_AOUT */
 #endif /* __A_OUT_GNU_H__ */
-- 
1.5.5.1

