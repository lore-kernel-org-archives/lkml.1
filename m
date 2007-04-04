Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbXDDTOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbXDDTOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbXDDTOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:14:51 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:65500 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbXDDTOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:14:39 -0400
Subject: [PATCH] Lguest32 print hex on bad reads and writes
From: Steven Rostedt <rostedt@goodmis.org>
To: virtualization@lists.osdl.org,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 15:14:31 -0400
Message-Id: <1175714071.9371.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the lguest32 error messages from bad reads and writes prints a
decimal integer for addresses. This is pretty annoying. So this patch
changes those to be hex outputs.

This is applied on top of my debug patch.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.21-rc5-mm2/drivers/lguest/core.c
===================================================================
--- linux-2.6.21-rc5-mm2.orig/drivers/lguest/core.c
+++ linux-2.6.21-rc5-mm2/drivers/lguest/core.c
@@ -220,7 +220,7 @@ u8 lgread_u8(struct lguest *lg, u32 addr
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr)
 	    || get_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad read address %u", addr);
+		kill_guest(lg, "bad read address %x", addr);
 	return val;
 }
 
@@ -231,7 +231,7 @@ u16 lgread_u16(struct lguest *lg, u32 ad
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr)
 	    || get_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad read address %u", addr);
+		kill_guest(lg, "bad read address %x", addr);
 	return val;
 }
 
@@ -242,7 +242,7 @@ u32 lgread_u32(struct lguest *lg, u32 ad
 	/* Don't let them access lguest binary */
 	if (!lguest_address_ok(lg, addr)
 	    || get_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad read address %u", addr);
+		kill_guest(lg, "bad read address %x", addr);
 	return val;
 }
 
@@ -250,7 +250,7 @@ void lgwrite_u32(struct lguest *lg, u32 
 {
 	if (!lguest_address_ok(lg, addr)
 	    || put_user(val, (u32 __user *)addr) != 0)
-		kill_guest(lg, "bad write address %u", addr);
+		kill_guest(lg, "bad write address %x", addr);
 }
 
 void lgread(struct lguest *lg, void *b, u32 addr, unsigned bytes)
@@ -259,7 +259,7 @@ void lgread(struct lguest *lg, void *b, 
 	    || copy_from_user(b, (void __user *)addr, bytes) != 0) {
 		/* copy_from_user should do this, but as we rely on it... */
 		memset(b, 0, bytes);
-		kill_guest(lg, "bad read address %u len %u", addr, bytes);
+		kill_guest(lg, "bad read address %x len %u", addr, bytes);
 	}
 }
 
@@ -268,7 +268,7 @@ void lgwrite(struct lguest *lg, u32 addr
 	if (addr + bytes < addr
 	    || !lguest_address_ok(lg, addr+bytes)
 	    || copy_to_user((void __user *)addr, b, bytes) != 0)
-		kill_guest(lg, "bad write address %u len %u", addr, bytes);
+		kill_guest(lg, "bad write address %x len %u", addr, bytes);
 }
 
 static void set_ts(unsigned int guest_ts)


