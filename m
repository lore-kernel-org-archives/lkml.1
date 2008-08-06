Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbYHFQC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbYHFQC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbYHFQCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:02:47 -0400
Received: from sender-01.it.helsinki.fi ([128.214.205.139]:34097 "EHLO
	sender-01.it.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbYHFQCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:02:46 -0400
X-Greylist: delayed 928 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 12:02:46 EDT
Message-Id: <200808061546.m76Fkwq1005199@ruuvi.it.helsinki.fi>
From: Vesa-Matti Kari <vmkari@cc.helsinki.fi>
To: sds@tycho.nsa.gov, jmorris@namei.org, eparis@parisplace.org
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Date: Wed, 6 Aug 2008 18:24:51 +0300
Subject: [PATCH] selinux: conditional expression type validation was off-by-one
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

expr_isvalid() in conditional.c was off-by-one and allowed
invalid expression type COND_LAST. However, it is this header file
that needs to be fixed. That way the if-statement's disjunction's
second component reads more naturally, "if expr type is greater than
the last allowed value" ( rather than using ">=" in conditional.c):

  if (expr->expr_type <= 0 || expr->expr_type > COND_LAST)

Signed-off-by: Vesa-Matti Kari <vmkari@cc.helsinki.fi>
---
 security/selinux/ss/conditional.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/conditional.h b/security/selinux/ss/conditional.h
index 65b9f83..53ddb01 100644
--- a/security/selinux/ss/conditional.h
+++ b/security/selinux/ss/conditional.h
@@ -28,7 +28,7 @@ struct cond_expr {
 #define COND_XOR	5 /* bool ^ bool */
 #define COND_EQ		6 /* bool == bool */
 #define COND_NEQ	7 /* bool != bool */
-#define COND_LAST	8
+#define COND_LAST	COND_NEQ
 	__u32 expr_type;
 	__u32 bool;
 	struct cond_expr *next;
-- 
1.5.4.1

