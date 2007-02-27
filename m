Return-Path: <linux-kernel-owner+w=401wt.eu-S1030582AbXB0Irg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582AbXB0Irg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030581AbXB0Ir2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:47:28 -0500
Received: from gw.goop.org ([64.81.55.164]:46823 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932851AbXB0IiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:21 -0500
Message-Id: <20070227081634.024521612@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 12/26] Xen-paravirt_ops: Fix patch site clobbers to include return register
Content-Disposition: inline; filename=paravirt-fix-clobbers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few clobbers to include the return register.  The clobbers set
is the set of all registers modified (or may be modified) by the code
snippet, regardless of whether it was deliberate or accidental.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>

---
 include/asm-i386/paravirt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -556,7 +556,7 @@ static inline unsigned long __raw_local_
 					   "popl %%edx; popl %%ecx")
 			     : "=a"(f): "m"(paravirt_ops.save_fl),
 			       paravirt_type(PARAVIRT_PATCH(save_fl)),
-			       paravirt_clobber(CLBR_NONE)
+			       paravirt_clobber(CLBR_EAX)
 			     : "memory", "cc");
 	return f;
 }
@@ -610,7 +610,7 @@ static inline unsigned long __raw_local_
 				 "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
 
 #define STI_STRING _paravirt_alt("pushl %%ecx; pushl %%edx;"		\
-				"call *paravirt_ops+%c[irq_enable];"	\
+				 "call *paravirt_ops+%c[irq_enable];"	\
 				 "popl %%edx; popl %%ecx",		\
 				 "%c[paravirt_cli_type]", "%c[paravirt_clobber]")
 

-- 

