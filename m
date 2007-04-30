Return-Path: <linux-kernel-owner+w=401wt.eu-S1946894AbXD3Xa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946894AbXD3Xa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 19:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946892AbXD3Xa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 19:30:56 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4511 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946894AbXD3Xaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 19:30:55 -0400
Date: Tue, 1 May 2007 01:30:53 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Allow arch to initialize arch field of the module structure
Message-ID: <Pine.LNX.4.64.0705010123240.2733@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This will later allow an arch to add module specific information via 
linker generated tables instead of poking directly in the module object 
structure.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

---
 include/linux/module.h |    3 +++
 scripts/mod/modpost.c  |    1 +
 2 files changed, 4 insertions(+)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h
+++ linux-2.6/include/linux/module.h
@@ -356,6 +356,9 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 };
+#ifndef MODULE_ARCH_INIT
+#define MODULE_ARCH_INIT {}
+#endif
 
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
Index: linux-2.6/scripts/mod/modpost.c
===================================================================
--- linux-2.6.orig/scripts/mod/modpost.c
+++ linux-2.6/scripts/mod/modpost.c
@@ -1249,6 +1249,7 @@ static void add_header(struct buffer *b,
 		buf_printf(b, "#ifdef CONFIG_MODULE_UNLOAD\n"
 			      " .exit = cleanup_module,\n"
 			      "#endif\n");
+	buf_printf(b, " .arch = MODULE_ARCH_INIT,\n");
 	buf_printf(b, "};\n");
 }
 
