Return-Path: <linux-kernel-owner+w=401wt.eu-S1764167AbXHVUxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764167AbXHVUxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933433AbXHVUwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:52:41 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60946 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933389AbXHVUwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:52:39 -0400
Message-id: <782311765865710289@wsc.cz>
In-reply-to: <2698018635706419125@wsc.cz>
Subject: [PATCH 2/2] Net: ath5k, remove sysctls
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <jeff@garzik.org>
Date: Wed, 22 Aug 2007 22:54:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, remove sysctls

Syscalls were buggy and defunct in later kernels (due to sysctl check).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 069bfbe93facb3468f579568434d18f1268a487c
tree 87c19ebf2c91d9fb07f1847adcb6098f2235eaaa
parent b01c0e9a02b248c3e2f2923da9728ba2c3961dee
author Jiri Slaby <jirislaby@gmail.com> Wed, 22 Aug 2007 22:48:41 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 22 Aug 2007 22:48:41 +0200

 drivers/net/wireless/ath5k_base.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k_base.c
index 2ce82ed..7f938c4 100644
--- a/drivers/net/wireless/ath5k_base.c
+++ b/drivers/net/wireless/ath5k_base.c
@@ -2440,21 +2440,13 @@ static struct pci_driver ath_pci_drv_id = {
 	.resume		= ath_pci_resume,
 };
 
-/*
- * Static (i.e. global) sysctls.  Note that the hal sysctls
- * are located under ours by sharing the setting for DEV_ATH.
- */
-enum {
-	DEV_ATH		= 9,			/* XXX known by hal */
-};
-
 static int mincalibrate = 1;
 static int maxcalibrate = INT_MAX / 1000;
 #define	CTL_AUTO	-2	/* cannot be CTL_ANY or CTL_NONE */
 
 static ctl_table ath_static_sysctls[] = {
 #if AR_DEBUG
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "debug",
 	  .mode		= 0644,
 	  .data		= &ath_debug,
@@ -2462,28 +2454,28 @@ static ctl_table ath_static_sysctls[] = {
 	  .proc_handler	= proc_dointvec
 	},
 #endif
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "countrycode",
 	  .mode		= 0444,
 	  .data		= &countrycode,
 	  .maxlen	= sizeof(countrycode),
 	  .proc_handler	= proc_dointvec
 	},
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "outdoor",
 	  .mode		= 0444,
 	  .data		= &outdoor,
 	  .maxlen	= sizeof(outdoor),
 	  .proc_handler	= proc_dointvec
 	},
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "xchanmode",
 	  .mode		= 0444,
 	  .data		= &xchanmode,
 	  .maxlen	= sizeof(xchanmode),
 	  .proc_handler	= proc_dointvec
 	},
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "calibrate",
 	  .mode		= 0644,
 	  .data		= &ath_calinterval,
@@ -2495,14 +2487,15 @@ static ctl_table ath_static_sysctls[] = {
 	{ 0 }
 };
 static ctl_table ath_ath_table[] = {
-	{ .ctl_name	= DEV_ATH,
+	{
 	  .procname	= "ath",
 	  .mode		= 0555,
 	  .child	= ath_static_sysctls
 	}, { 0 }
 };
 static ctl_table ath_root_table[] = {
-	{ .ctl_name	= CTL_DEV,
+	{
+	  .ctl_name	= CTL_DEV,
 	  .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= ath_ath_table
