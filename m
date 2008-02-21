Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbYBUPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbYBUPgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 10:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYBUPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 10:36:06 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:17660 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbYBUPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 10:36:04 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.25] lib/vsprintf.c: Fix bug omitting minus sign of numbers (module_param)
Date: Thu, 21 Feb 2008 16:29:57 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211629.57765.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/vsprintf.c: Fix bug omitting minus sign of numbers (module_param)

This exists in 2.6.25 only.

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 lib/vsprintf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index fd987b1..6021757 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -234,7 +234,7 @@ int strict_strto##type(const char *cp, unsigned int base, valtype *res)	\
 	int ret;							\
 	if (*cp == '-') {						\
 		ret = strict_strtou##type(cp+1, base, res);		\
-		if (ret != 0)						\
+		if (!ret)						\
 			*res = -(*res);					\
 	} else								\
 		ret = strict_strtou##type(cp, base, res);		\
-- 
1.5.2


