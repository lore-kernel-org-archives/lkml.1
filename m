Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXBLDfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXBLDfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:35:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbXBLDfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:35:04 -0500
Received: from ozlabs.org ([203.10.76.45]:50844 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943AbXBLDfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:35:03 -0500
Subject: [PATCH 3/7] cleanup: Make hvc_console.c compile on non-PowerPC
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1171251185.10409.4.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:34:18 +1100
Message-Id: <1171251258.10409.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's a really nice console helper (esp. for virtual console
drivers) in drivers/char/hvc_console.c.  It has only ever been used
for PowerPC, though, so it uses NO_IRQ which is only defined there.

Let's fix that so it's more widely useful.  By, say, lguest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -48,6 +48,10 @@
 #define HVC_MINOR	0
 
 #define TIMEOUT		(10)
+
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
 
 /*
  * Wait this long per iteration while trying to push buffered data to the


