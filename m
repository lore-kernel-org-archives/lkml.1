Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbZGVOBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbZGVOBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZGVOBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:01:43 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:42586 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbZGVOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:01:24 -0400
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: linux@arm.linux.org.uk, hpa@zytor.com
Cc: alain@knaff.lu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: [PATCH 2/5] include/linux/unaligned/{l,b}e_byteshift.h: Fix usage for compressed kernels
Date: Wed, 22 Jul 2009 16:01:16 +0200
Message-Id: <1248271279-9920-2-git-send-email-albin.tonnerre@free-electrons.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248271279-9920-1-git-send-email-albin.tonnerre@free-electrons.com>
References: <1248271279-9920-1-git-send-email-albin.tonnerre@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unaligned accesses are required for uncompressing a kernel (such as
for LZO decompression on ARM in a patch that follows), including
<linux/kernel.h> causes issues as it brings in a lot of things that are
not available in the decompression environment.
However, those files apparently use nothing from <linux/kernel.h>, all
they need is the declaration of types such as u32 or u64, so
<linux/types.h> should be enough

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 include/linux/unaligned/be_byteshift.h |    2 +-
 include/linux/unaligned/le_byteshift.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/unaligned/be_byteshift.h b/include/linux/unaligned/be_byteshift.h
index 46dd12c..9356b24 100644
--- a/include/linux/unaligned/be_byteshift.h
+++ b/include/linux/unaligned/be_byteshift.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_BE_BYTESHIFT_H
 #define _LINUX_UNALIGNED_BE_BYTESHIFT_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 static inline u16 __get_unaligned_be16(const u8 *p)
 {
diff --git a/include/linux/unaligned/le_byteshift.h b/include/linux/unaligned/le_byteshift.h
index 59777e9..be376fb 100644
--- a/include/linux/unaligned/le_byteshift.h
+++ b/include/linux/unaligned/le_byteshift.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_LE_BYTESHIFT_H
 #define _LINUX_UNALIGNED_LE_BYTESHIFT_H
 
-#include <linux/kernel.h>
+#include <linux/types.h>
 
 static inline u16 __get_unaligned_le16(const u8 *p)
 {
-- 
1.6.0.4

