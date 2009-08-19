Return-Path: <linux-kernel-owner+w=401wt.eu-S1751694AbZHSJj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbZHSJj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZHSJj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:39:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:54910 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbZHSJjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:39:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,407,1246863600"; 
   d="scan'208,223";a="542789975"
Date: Wed, 19 Aug 2009 17:38:54 +0800
From: Alek Du <alek.du@intel.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <linux-kbuild@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] Makefile: Fix size_append issue for bzip2/lzma kernel
Message-ID: <20090819173854.2250758f@dxy.sh.intel.com>
Organization: Intel Corp.
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6d755cbd7a136a4314f6976275aaa6c9d10bf3e4 Mon Sep 17 00:00:00 2001
From: Alek Du <alek.du@intel.com>
Date: Wed, 19 Aug 2009 17:18:39 +0800
Subject: [PATCH] Makefile: Fix size_append issue for bzip2/lzma kernel

The Makefile.lib will call "echo -ne" to append uncompressed kernel size to
bzip2/lzma kernel image. The "echo" here depends on the shell that /bin/sh pointing
to. On Ubuntu system, the /bin/sh is pointing to dash, which does not support
"echo -e" at all. Use /bin/echo instead of shell echo should always be safe.

Signed-off-by: Alek Du <alek.du@intel.com>
---
 scripts/Makefile.lib |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 7a77787..c63c941 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -208,7 +208,7 @@ cmd_gzip = (cat $(filter-out FORCE,$^) | gzip -f -9 > $@) || \
 
 # Bzip2 and LZMA do not include size in file... so we have to fake that;
 # append the size as a 32-bit littleendian number as gzip does.
-size_append = echo -ne $(shell						\
+size_append = /bin/echo -ne $(shell						\
 dec_size=0;								\
 for F in $1; do								\
 	fsize=$$(stat -c "%s" $$F);					\
-- 
1.6.0.4
