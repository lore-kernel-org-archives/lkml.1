Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXLGEM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXLGEM4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 23:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbXLGEMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 23:12:48 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51704 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbXLGEMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 23:12:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 06 Dec 2007 23:12:46 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: remove unused 'mode' from the mmc_host structure
Message-id: <alpine.LFD.0.99999.0712062257310.555@xanadu.home>
User-Agent: Alpine 0.99999 (LFD 814 2007-11-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field and corresponding defines are simply never used anywhere
in the code.  But its mere presence is enough to confuse some host 
driver authors who attempt to rely on it.  Let's eliminate the 
possibility for confusion and remove it entirely.

Signed-off-by: Nicolas Pitre <nico@cam.org>
---

yes, it's the second host driver I'm reviewing with this issue...

diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 125eee1..7ab962f 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -118,10 +118,6 @@ struct mmc_host {
 	unsigned int		removed:1;	/* host is being removed */
 #endif
 
-	unsigned int		mode;		/* current card mode of host */
-#define MMC_MODE_MMC		0
-#define MMC_MODE_SD		1
-
 	struct mmc_card		*card;		/* device attached to this host */
 
 	wait_queue_head_t	wq;
