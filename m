Return-Path: <linux-kernel-owner+w=401wt.eu-S965928AbXDBVSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965928AbXDBVSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 17:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965920AbXDBVSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 17:18:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965928AbXDBVSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 17:18:30 -0400
Date: Mon, 2 Apr 2007 16:46:10 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.osdl.org
Subject: [PATCH 1/2] Makefile for common loader
Message-ID: <20070402194610.GB7711@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="s/l3CgOIzMHHjg/5"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch moves lguest's loader Makefile one level bellow, and adds
arch-specific code to arch directories

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="lgmake.patch"

--- i386/Makefile	2007-04-02 16:11:56.000000000 -0300
+++ Makefile	2007-04-02 16:11:56.000000000 -0300
@@ -1,12 +1,13 @@
 # This creates the demonstration utility "lguest" which runs a Linux guest.
 
-# We rely on CONFIG_PAGE_OFFSET to know where to put lguest binary.
-# Some shells (dash - ubunu) can't handle numbers that big so we cheat.
-include ../../../.config
-LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
 
-CFLAGS:=-Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
-	-static -DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds
+#we could uname -i, but it seems to return unknown on a bunch locations
+ARCH:=$(shell uname -m | sed s/i[3456]86/i386/)
+
+include $(ARCH)/defines
+
+CFLAGS:=-g -Wall -Wmissing-declarations -Wmissing-prototypes -O3 \
+	-static -DLGUEST_GUEST_TOP="$(LGUEST_GUEST_TOP)" -Wl,-T,lguest.lds -I$(ARCH)
 LDLIBS:=-lz
 
 all: lguest.lds lguest
--- /dev/null	2007-04-02 15:35:49.510433377 -0300
+++ i386/defines	2007-04-02 16:13:43.000000000 -0300
@@ -0,0 +1,4 @@
+# We rely on CONFIG_PAGE_OFFSET to know where to put lguest binary.
+# Some shells (dash - ubunu) can't handle numbers that big so we cheat.
+include ../../.config
+LGUEST_GUEST_TOP := ($(CONFIG_PAGE_OFFSET) - 0x08000000)
--- /dev/null	2007-04-02 15:35:49.510433377 -0300
+++ x86_64/defines	2007-04-02 16:11:56.000000000 -0300
@@ -0,0 +1,4 @@
+# For now on x86_64 we'll hard code the location of the lguest binary loader.
+# But when we can get a relocatable kernel, we'll have to work to make this
+# dynamic.
+LGUEST_GUEST_TOP := 0x7f000000

--s/l3CgOIzMHHjg/5--
