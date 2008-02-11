Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYBKSFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYBKSFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYBKSFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:05:46 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:52151 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYBKSFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:05:45 -0500
Date: Mon, 11 Feb 2008 10:05:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dwmw2@infradead.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH] audit: fix auditsc printk format warning
Message-Id: <20080211100501.30c416c9.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

linux-2.6.25-rc1/kernel/auditsc.c:1077: warning: format '%ld' expects type 'long int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/auditsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25-rc1.orig/kernel/auditsc.c
+++ linux-2.6.25-rc1/kernel/auditsc.c
@@ -1073,7 +1073,7 @@ static int audit_log_single_execve_arg(s
 		 * so we can be sure nothing was lost.
 		 */
 		if ((i == 0) && (too_long))
-			audit_log_format(*ab, "a%d_len=%ld ", arg_num,
+			audit_log_format(*ab, "a%d_len=%zd ", arg_num,
 					 has_cntl ? 2*len : len);
 
 		/*
