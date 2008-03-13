Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbYCMWzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbYCMWzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758272AbYCMWzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:55:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbYCMWzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:55:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/2] MIPS Alchemy: Crapectomy after removal of pm_send_all calls.
Date: Thu, 13 Mar 2008 23:54:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>
References: <200803132351.19794.rjw@sisk.pl>
In-Reply-To: <200803132351.19794.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132354.10652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>

[MIPS] Alchemy: Crapectomy after removal of pm_send_all calls.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/mips/au1000/common/power.c |   20 --------------------
 1 file changed, 20 deletions(-)

Index: linux-2.6/arch/mips/au1000/common/power.c
===================================================================
--- linux-2.6.orig/arch/mips/au1000/common/power.c
+++ linux-2.6/arch/mips/au1000/common/power.c
@@ -283,18 +283,6 @@ static int pm_do_sleep(ctl_table * ctl, 
 	return 0;
 }
 
-static int pm_do_suspend(ctl_table * ctl, int write, struct file *file,
-			 void __user *buffer, size_t * len, loff_t *ppos)
-{
-	if (!write) {
-		*len = 0;
-	} else {
-		suspend_mode = 1;
-	}
-	return 0;
-}
-
-
 static int pm_do_freq(ctl_table * ctl, int write, struct file *file,
 		      void __user *buffer, size_t * len, loff_t *ppos)
 {
@@ -408,14 +396,6 @@ static int pm_do_freq(ctl_table * ctl, i
 
 static struct ctl_table pm_table[] = {
 	{
-		.ctl_name 	= CTL_UNNUMBERED,
-		.procname	= "suspend",
-		.data		= NULL,
-		.maxlen		= 0,
-		.mode		= 0600,
-		.proc_handler	= &pm_do_suspend
-	},
-	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sleep",
 		.data		= NULL,
