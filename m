Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbYGHRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbYGHRNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYGHRNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:13:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57761 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYGHRNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:13:37 -0400
Message-Id: <20080708170043.452775000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:18 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 03/11] rework try_then_request_module to do less in
	non-modular kernels
Content-Disposition: inline; filename=config-kmod-try-then-rework.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reworks try_then_request_module to only invoke the "lookup"
function "x" once when the kernel is not modular.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/kmod.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- everything.orig/include/linux/kmod.h	2008-07-08 18:46:21.000000000 +0200
+++ everything/include/linux/kmod.h	2008-07-08 18:48:34.000000000 +0200
@@ -29,11 +29,12 @@
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
 extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
+#define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), (x)))
 #else
 static inline int request_module(const char * name, ...) { return -ENOSYS; }
+#define try_then_request_module(x, mod...) (x)
 #endif
 
-#define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), (x)))
 
 struct key;
 struct file;

-- 

