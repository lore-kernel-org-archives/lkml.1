Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXFOOuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXFOOuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbXFOOtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:49:08 -0400
Received: from gw.goop.org ([64.81.55.164]:34361 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbXFOOtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:49:06 -0400
Message-Id: <20070615005013.190869383@goop.org>
References: <20070615004818.424726597@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 17:48:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: [PATCH 06/10] add WEAK() for creating weak asm labels
Content-Disposition: inline; filename=weak-linkage.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/linux/linkage.h |    6 ++++++
 1 file changed, 6 insertions(+)

===================================================================
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -34,6 +34,12 @@
   name:
 #endif
 
+#ifndef WEAK
+#define WEAK(name)	   \
+	.weak name;	   \
+	name:
+#endif
+
 #define KPROBE_ENTRY(name) \
   .pushsection .kprobes.text, "ax"; \
   ENTRY(name)

-- 

