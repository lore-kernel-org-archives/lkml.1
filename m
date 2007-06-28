Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbXF1WDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbXF1WDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763572AbXF1WD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:03:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28288 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763386AbXF1WD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:03:27 -0400
Date: Thu, 28 Jun 2007 15:05:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@suse.cz, akpm <akpm@linux-foundation.org>
Subject: [PATCH] ALSA: more section mismatches
Message-Id: <20070628150515.0d819891.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warnings:

WARNING: sound/built-in.o(.exit.text+0x3ad): Section mismatch: reference to .init.text: (between 'sb_exit' and 'unload_uart6850')
WARNING: sound/built-in.o(.exit.text+0x753): Section mismatch: reference to .init.text: (between 'snd_mts64_module_exit' and 'snd_portman_module_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/drivers/mts64.c |    2 +-
 sound/oss/sb_card.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2622-rc6.orig/sound/drivers/mts64.c
+++ linux-2622-rc6/sound/drivers/mts64.c
@@ -1048,7 +1048,7 @@ static struct platform_driver snd_mts64_
 /*********************************************************************
  * module init stuff
  *********************************************************************/
-static void __init_or_module snd_mts64_unregister_all(void)
+static void snd_mts64_unregister_all(void)
 {
 	int i;
 
--- linux-2622-rc6.orig/sound/oss/sb_card.c
+++ linux-2622-rc6/sound/oss/sb_card.c
@@ -290,7 +290,7 @@ static struct pnp_card_driver sb_pnp_dri
 MODULE_DEVICE_TABLE(pnp_card, sb_pnp_card_table);
 #endif /* CONFIG_PNP */
 
-static void __init_or_module sb_unregister_all(void)
+static void sb_unregister_all(void)
 {
 #ifdef CONFIG_PNP
 	if (pnp_registered)
