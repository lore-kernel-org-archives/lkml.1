Return-Path: <linux-kernel-owner+w=401wt.eu-S1760706AbXJDLdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706AbXJDLdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXJDL2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:28:52 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:51243 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbXJDL23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:28:29 -0400
Message-Id: <20071004112830.596222209@de.ibm.com>
References: <20071004112706.574737175@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 04 Oct 2007 13:27:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 22/34] remove packed attribute from ext_int_info_t.
Content-Disposition: inline; filename=022-ext-info.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

ext_int_info_t is no longer used in entry(64).S Instead do_extint is a C
function that handles the hash search.
As the structure is handled in C code, we can also remove the packed
attribute to avoid alignment issues. (Currently there is no alignment
problem in ext_int_info_t, even if packet)

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/asm-s390/s390_ext.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: quilt-2.6/include/asm-s390/s390_ext.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/s390_ext.h
+++ quilt-2.6/include/asm-s390/s390_ext.h
@@ -5,7 +5,7 @@
  *  include/asm-s390/s390_ext.h
  *
  *  S390 version
- *    Copyright (C) 1999,2000 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright IBM Corp. 1999,2007
  *    Author(s): Holger Smolinski (Holger.Smolinski@de.ibm.com),
  *               Martin Schwidefsky (schwidefsky@de.ibm.com)
  */
@@ -14,15 +14,11 @@
 
 typedef void (*ext_int_handler_t)(__u16 code);
 
-/*
- * Warning: if you change ext_int_info_t you have to change the
- * external interrupt handler in entry.S too.
- */ 
 typedef struct ext_int_info_t {
 	struct ext_int_info_t *next;
 	ext_int_handler_t handler;
 	__u16 code;
-} __attribute__ ((packed)) ext_int_info_t;
+} ext_int_info_t;
 
 extern ext_int_info_t *ext_int_hash[];
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

