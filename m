Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbZDIKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbZDIKEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 06:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758757AbZDIKEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 06:04:34 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:34958 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759285AbZDIKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 06:04:34 -0400
Date: Thu, 9 Apr 2009 12:04:31 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] namespaces: Move get_mq() inside #ifdef CONFIG_SYSCTL
Message-ID: <alpine.LRH.2.00.0904091203370.771@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| ipc/mq_sysctl.c:26: warning: 'get_mq' defined but not used

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 ipc/mq_sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index 89f60ec..24ae46d 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -22,6 +22,7 @@
 #define MIN_MSGSIZEMAX	128		/* min value for msgsize_max */
 #define MAX_MSGSIZEMAX	(8192*128)	/* max value for msgsize_max */
 
+#ifdef CONFIG_PROC_SYSCTL
 static void *get_mq(ctl_table *table)
 {
 	char *which = table->data;
@@ -30,7 +31,6 @@ static void *get_mq(ctl_table *table)
 	return which;
 }
 
-#ifdef CONFIG_PROC_SYSCTL
 static int proc_mq_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
1.6.0.4

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
