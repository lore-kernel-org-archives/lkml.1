Return-Path: <linux-kernel-owner+w=401wt.eu-S1763941AbXFCBui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763941AbXFCBui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 21:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763143AbXFCBuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 21:50:32 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50952 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762746AbXFCBub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 21:50:31 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: Prakash Punnoor <prakash@punnoor.de>
Subject: [Trivial Patch] Remove JFFS2 dependency on internal Zlib header (take 2)
Date: Sat, 2 Jun 2007 21:50:27 -0400
User-Agent: KMail/1.9.6
References: <200706021520.36478.dhazelton@enter.net> <46620979.9020901@punnoor.de>
In-Reply-To: <46620979.9020901@punnoor.de>
Cc: dwmw2@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_j5hYGp2do0XB7zv"
Message-Id: <200706022150.27746.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_j5hYGp2do0XB7zv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

No code besides zlib itself should depend on linux/zutil.h - the only item 
JFFS2 uses from that header is a constant that is defined in RFC 1950 and 
should never change. This patch mirrors the #define in zutil.h and removes 
the #include.

Signed-off-by: Daniel Hazelton <dhazelton@enter.net>

DRH

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..f4519db 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"

@@ -29,6 +28,13 @@
        */
 #define STREAM_END_SPACE 12

+/*
+ * PRESET_DICT is set in the internal (aka: private) zlib header zutil.h
+ * the value - 0x20 - is defined in RFC 1950, so making a duplicate
+ * definition here to remove this code's dependency on that file is safe.
+ */
+#define PRESET_DICT 0x20
+
 static DEFINE_MUTEX(deflate_mutex);
 static DEFINE_MUTEX(inflate_mutex);
 static z_stream inf_strm, def_strm;

--Boundary-00=_j5hYGp2do0XB7zv
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="remove-jffs2-zutil.h-dependency.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="remove-jffs2-zutil.h-dependency.patch"

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..f4519db 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"
 
@@ -29,6 +28,13 @@
 	*/
 #define STREAM_END_SPACE 12
 
+/*
+ * PRESET_DICT is set in the internal (aka: private) zlib header zutil.h
+ * the value - 0x20 - is defined in RFC 1950, so making a duplicate
+ * definition here to remove this code's dependency on that file is safe.
+ */
+#define PRESET_DICT 0x20
+
 static DEFINE_MUTEX(deflate_mutex);
 static DEFINE_MUTEX(inflate_mutex);
 static z_stream inf_strm, def_strm;

--Boundary-00=_j5hYGp2do0XB7zv--
