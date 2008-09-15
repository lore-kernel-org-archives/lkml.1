Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYIOK2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYIOK2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 06:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYIOK2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 06:28:42 -0400
Received: from host254-130-static.190-82-b.business.telecomitalia.it ([82.190.130.254]:50011
	"EHLO nausicaa2.coritel.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbYIOK2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 06:28:41 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2008 06:28:41 EDT
Message-ID: <48CE33D7.1040203@coritel.it>
Date: Mon, 15 Sep 2008 12:07:19 +0200
From: Marco Stornelli <marco.stornelli@coritel.it>
Organization: CoRiTeL
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Linux AVR32 <kernel@avr32linux.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] avr32: added mem kernel command line option support
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Added support for the mem kernel command line option
Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
--- setup.c.orig    2008-09-15 11:30:00.000000000 +0200
+++ setup.c    2008-09-15 11:30:17.000000000 +0200
@@ -283,6 +283,25 @@ static int __init early_parse_fbmem(char
 }
 early_param("fbmem", early_parse_fbmem);
 
+/*
+ * Pick out the memory size.  We look for mem=size@start,
+ * where start and size are "size[KkMm]"
+ */
+static int __init early_mem(char **p)
+{
+    unsigned long size, start;
+
+    start = system_ram->start;
+    size  = memparse(*p, p);
+    if (**p == '@')
+        start = memparse(*p + 1, p);
+
+    system_ram->start = start;
+    system_ram->end = system_ram->start + size - 1;
+    return 0;
+}
+early_param("mem", early_mem);
+
 static int __init parse_tag_core(struct tag *tag)
 {
     if (tag->hdr.size > 2) {
