Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYFXA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYFXA3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYFXA3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:29:05 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:64283 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbYFXA3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OmvoIGO2Z9O5DfnA1keyi2MynuDuakto0U/99m4hN+f2CfoWggu8ikEfYFJVtv2Kvj
         /eGD0UTEnOxp8PXmzVeliwj1Hcp2vZt2+z9XhULxoExPjzdahP21+3hpU5xtD5Wcpbq0
         L4WZ3OaDYYuxYxkwjMsTIxd4tWIaYkNKevTk0=
Subject: [PATCH 2/3] m32r: Use packed struct rather than memmove for
	unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Jun 2008 17:28:59 -0700
Message-Id: <1214267339.21092.57.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
﻿There are only 3 arches that use the memmove implementation, do you see
any problems with using the packed struct implementation so the memmove
version could be removed?

 include/asm-m32r/unaligned.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-m32r/unaligned.h b/include/asm-m32r/unaligned.h
index 377eb20..86ea884 100644
--- a/include/asm-m32r/unaligned.h
+++ b/include/asm-m32r/unaligned.h
@@ -2,13 +2,13 @@
 #define _ASM_M32R_UNALIGNED_H
 
 #if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/le_struct.h>
 # include <linux/unaligned/be_byteshift.h>
 # include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_le
 # define put_unaligned	__put_unaligned_le
 #else
-# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/be_struct.h>
 # include <linux/unaligned/le_byteshift.h>
 # include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_be
-- 
1.5.6.290.gc4e15


