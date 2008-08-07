Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbYHGMdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbYHGMdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbYHGMcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:32:16 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:4415 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbYHGMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:32:14 -0400
From: Swen Schillig <swen@vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/vsprintf.c: wrong conversion function used
Date: Thu, 7 Aug 2008 11:24:05 +0200
User-Agent: KMail/1.9.5
Organization: IBM
Cc: Andrew Morton <akpm@linux-foundation.org>, Yi Yang <yi.y.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071124.06160.swen@vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swen Schillig <swen@vnet.ibm.com>

The macro define_strict_strtoux() is using the simple_strtoul ()
function as opposed to the simple_strtoull() function.
This leads to false conversions on non-64bit 
machines (here 31bit System z).

The following patch fixes the issue introduced by 

commit 06b2a76d25d3cfbd14680021c1d356c91be6904e 
Author: Yi Yang <yi.y.yang@intel.com> 
Date:   Fri Feb 8 04:21:57 2008 -0800 

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: HEAD/lib/vsprintf.c
===================================================================
--- HEAD.orig/lib/vsprintf.c
+++ HEAD/lib/vsprintf.c
@@ -220,7 +220,7 @@ int strict_strtou##type(const char *cp, 
 	if (len == 0)							\
 		return -EINVAL;						\
 									\
-	val = simple_strtoul(cp, &tail, base);				\
+	val = simple_strtoull(cp, &tail, base);				\
 	if ((*tail == '\0') ||						\
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
 		*res = val;						\
