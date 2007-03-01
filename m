Return-Path: <linux-kernel-owner+w=401wt.eu-S1422638AbXCAX7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422638AbXCAX7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161274AbXCAX46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:56:58 -0500
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:47902 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161280AbXCAX4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:56:49 -0500
Message-Id: <20070301232527.755495278@goop.org>
References: <20070301232443.195603797@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 01 Mar 2007 15:24:55 -0800
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

