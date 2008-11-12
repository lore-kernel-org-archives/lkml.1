Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbYKLMYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbYKLMYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYKLMXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:23:32 -0500
Received: from ozlabs.org ([203.10.76.45]:36501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293AbYKLMXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:23:30 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:23:27 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 7/7] lguest: change virtio ring alignment.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122253.27332.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just to test that the constant is wired through correctly.

lguest has no ABI so I could apply this patch, but it breaks the
"don't be an asshole" rule.

diff -r 19e5f3f3a4be Documentation/lguest/Makefile
--- a/Documentation/lguest/Makefile	Wed Nov 12 22:27:50 2008 +1030
+++ b/Documentation/lguest/Makefile	Wed Nov 12 22:38:52 2008 +1030
@@ -4,5 +4,7 @@
 
 all: lguest
 
+lguest: ../../include/linux/lguest_launcher.h
+
 clean:
 	rm -f lguest
diff -r 19e5f3f3a4be include/linux/lguest_launcher.h
--- a/include/linux/lguest_launcher.h	Wed Nov 12 22:27:50 2008 +1030
+++ b/include/linux/lguest_launcher.h	Wed Nov 12 22:38:52 2008 +1030
@@ -60,5 +60,6 @@
 	LHREQ_BREAK, /* + on/off flag (on blocks until someone does off) */
 };
 
-#define LGUEST_VRING_ALIGN	4096
+/* A cacheline is enough separation between producer and consumer. */
+#define LGUEST_VRING_ALIGN	128
 #endif /* _LINUX_LGUEST_LAUNCHER */


