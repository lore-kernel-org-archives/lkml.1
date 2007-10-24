Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbXJXABd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbXJXABd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 20:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXJXAB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 20:01:26 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:46188 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbXJXABZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 20:01:25 -0400
Message-ID: <471E8B52.9050500@tiscali.nl>
Date: Wed, 24 Oct 2007 02:01:22 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Unlock when ssp tries to close an invalid port
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Unlock when ssp tries to close an invalid port
    Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/arm/mach-pxa/ssp.c b/arch/arm/mach-pxa/ssp.c
index 71766ac..422afee 100644
--- a/arch/arm/mach-pxa/ssp.c
+++ b/arch/arm/mach-pxa/ssp.c
@@ -309,6 +309,7 @@ void ssp_exit(struct ssp_dev *dev)
 
     	if (dev->port > PXA_SSP_PORTS || dev->port == 0) {
 		printk(KERN_WARNING "SSP: tried to close invalid port\n");
+		mutex_unlock(&mutex);
 		return;
 	}
 

