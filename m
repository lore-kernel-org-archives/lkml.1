Return-Path: <linux-kernel-owner+w=401wt.eu-S1763438AbYDYSju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763438AbYDYSju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYDYSj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:39:26 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:18887 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYDYSjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:39:25 -0400
Message-Id: <20080425183924.268327267@ldl.fc.hp.com>
References: <20080425183807.366134771@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 12:38:08 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 01/54] PNP: turn on -DDEBUG when CONFIG_PNP_DEBUG is set
Content-Disposition: inline; filename=pnp-turn-on-debug-in-makefiles
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turn on -DDEBUG in CFLAGS when CONFIG_PNP_DEBUG=y.  This makes
dev_dbg() do what you expect.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work10/drivers/pnp/isapnp/Makefile
===================================================================
--- work10.orig/drivers/pnp/isapnp/Makefile	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/isapnp/Makefile	2008-04-25 11:14:41.000000000 -0600
@@ -5,3 +5,7 @@
 isapnp-proc-$(CONFIG_PROC_FS) = proc.o
 
 obj-y := core.o compat.o $(isapnp-proc-y)
+
+ifeq ($(CONFIG_PNP_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
Index: work10/drivers/pnp/pnpacpi/Makefile
===================================================================
--- work10.orig/drivers/pnp/pnpacpi/Makefile	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/pnpacpi/Makefile	2008-04-25 11:14:41.000000000 -0600
@@ -3,3 +3,7 @@
 #
 
 obj-y := core.o rsparser.o
+
+ifeq ($(CONFIG_PNP_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
Index: work10/drivers/pnp/pnpbios/Makefile
===================================================================
--- work10.orig/drivers/pnp/pnpbios/Makefile	2008-04-25 11:12:17.000000000 -0600
+++ work10/drivers/pnp/pnpbios/Makefile	2008-04-25 11:14:41.000000000 -0600
@@ -5,3 +5,7 @@
 pnpbios-proc-$(CONFIG_PNPBIOS_PROC_FS) = proc.o
 
 obj-y := core.o bioscalls.o rsparser.o $(pnpbios-proc-y)
+
+ifeq ($(CONFIG_PNP_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif

-- 
