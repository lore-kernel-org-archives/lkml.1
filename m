Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbXJBXg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbXJBXg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXJBXgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:36:19 -0400
Received: from ozlabs.org ([203.10.76.45]:51135 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884AbXJBXgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:36:19 -0400
Subject: [PATCH 2/5] add WEAK() for creating weak asm labels
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <1191368106.17826.43.camel@localhost.localdomain>
References: <1191368052.17826.40.camel@localhost.localdomain>
	 <1191368106.17826.43.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 09:35:54 +1000
Message-Id: <1191368154.17826.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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


