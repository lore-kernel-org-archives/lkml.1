Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZBBVwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZBBVwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZBBVwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:52:46 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:52307 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbZBBVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:52:45 -0500
Date: Mon, 2 Feb 2009 13:52:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH -mmotm/resend] sysrq: emergency thaw only if CONFIG_BLOCK
 enabled
Message-Id: <20090202135213.d9563e47.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.49876B0E.029B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

sysrq's new emergency_thaw_all() is only available when CONFIG_BLOCK=y:

drivers/char/sysrq.c:351: error: implicit declaration of function 'emergency_thaw_all'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/sysrq.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- mmotm-2009-0131-0108.orig/drivers/char/sysrq.c
+++ mmotm-2009-0131-0108/drivers/char/sysrq.c
@@ -346,6 +346,7 @@ static struct sysrq_key_op sysrq_moom_op
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
 
+#ifdef CONFIG_BLOCK
 static void sysrq_handle_thaw(int key, struct tty_struct *tty)
 {
 	emergency_thaw_all();
@@ -356,6 +357,7 @@ static struct sysrq_key_op sysrq_thaw_op
 	.action_msg	= "Emergency Thaw of all frozen filesystems",
 	.enable_mask	= SYSRQ_ENABLE_SIGNAL,
 };
+#endif
 
 static void sysrq_handle_kill(int key, struct tty_struct *tty)
 {
@@ -409,7 +411,11 @@ static struct sysrq_key_op *sysrq_key_ta
 	NULL,				/* g */
 	NULL,				/* h - reserved for help */
 	&sysrq_kill_op,			/* i */
+#ifdef CONFIG_BLOCK
 	&sysrq_thaw_op,			/* j */
+#else
+	NULL,				/* j */
+#endif
 	&sysrq_SAK_op,			/* k */
 #ifdef CONFIG_SMP
 	&sysrq_showallcpus_op,		/* l */

