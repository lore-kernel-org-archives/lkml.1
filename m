Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZA1NhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZA1NhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 08:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbZA1Nf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:35:59 -0500
Received: from ozlabs.org ([203.10.76.45]:55201 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbZA1Nf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:35:57 -0500
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 29 Jan 2009 00:05:52 +1030
CC: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 5/6] module: make modversion_info contain a pointer, not an array.
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200901290005.52819.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With allmodconfig (minus non-building modules) on 32-bit x86:
Total size of modules before: 60009790 bytes
Total size of modules after: 55927866 bytes

Saving 7% of module size for CONFIG_MODVERSIONS=y; and these sections
are kept resident as well.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -37,10 +37,12 @@ struct kernel_symbol
 	const char *name;
 };
 
+/* This is put in the __versions section of a module to indicate the version
+ * it expects for unknown symbols. */
 struct modversion_info
 {
 	unsigned long crc;
-	char name[MODULE_NAME_LEN];
+	char *name;
 };
 
 struct module;

