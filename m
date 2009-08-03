Return-Path: <linux-kernel-owner+w=401wt.eu-S932235AbZHCO6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbZHCO6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbZHCO6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:58:41 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:42197 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbZHCO6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:58:40 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: sam@ravnborg.org
Cc: hpa@zytor.com, linux@arm.linux.org.uk, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH 1/6] lib/decompress_*: only include <linux/slab.h> if STATIC is not defined
Date: Mon,  3 Aug 2009 16:58:16 +0200
Message-Id: <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090731093107.GA29704@merkur.ravnborg.org>
References: <20090731093107.GA29704@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These includes were added by 079effb6933f34b9b1b67b08bd4fd7fb672d16ef to
fix the build when using kmemtrace. However this is not necessary when
used to create a compressed kernel, and actually creates issues (brings
a lot of things unavailable in the decompression environment), so don't
include it if STATIC is defined.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 lib/decompress_bunzip2.c |    2 +-
 lib/decompress_inflate.c |    2 +-
 lib/decompress_unlzma.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 708e2a8..14b0c7d 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -47,10 +47,10 @@
 
 #ifndef STATIC
 #include <linux/decompress/bunzip2.h>
+#include <linux/slab.h>
 #endif /* !STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #ifndef INT_MAX
 #define INT_MAX 0x7fffffff
diff --git a/lib/decompress_inflate.c b/lib/decompress_inflate.c
index e36b296..fc30d50 100644
--- a/lib/decompress_inflate.c
+++ b/lib/decompress_inflate.c
@@ -19,11 +19,11 @@
 #include "zlib_inflate/inflate.h"
 
 #include "zlib_inflate/infutil.h"
+#include <linux/slab.h>
 
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define INBUF_LEN (16*1024)
 
diff --git a/lib/decompress_unlzma.c b/lib/decompress_unlzma.c
index 32123a1..f078c88 100644
--- a/lib/decompress_unlzma.c
+++ b/lib/decompress_unlzma.c
@@ -31,10 +31,10 @@
 
 #ifndef STATIC
 #include <linux/decompress/unlzma.h>
+#include <linux/slab.h>
 #endif /* STATIC */
 
 #include <linux/decompress/mm.h>
-#include <linux/slab.h>
 
 #define	MIN(a, b) (((a) < (b)) ? (a) : (b))
 
-- 
1.6.3.3

