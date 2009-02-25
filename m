Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbZBYXLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbZBYXLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 18:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759157AbZBYXLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 18:11:33 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:49403 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763502AbZBYXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 18:11:31 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 4/5] drivers/isdn/hardware/icon: fix sparse warning: cast
	truncates bits
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Feb 2009 00:11:23 +0100
Message-ID: <20090225231111.5377.77854.stgit@localhost.localdomain>
In-Reply-To: <20090225230737.5377.31370.stgit@localhost.localdomain>
References: <20090225230737.5377.31370.stgit@localhost.localdomain>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  drivers/isdn/hardware/eicon/debug.c:1201:32: warning: cast truncates bits from constant value (1000 becomes 0)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/isdn/hardware/eicon/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/debug.c b/drivers/isdn/hardware/eicon/debug.c
index 84318ec..33ce89e 100644
--- a/drivers/isdn/hardware/eicon/debug.c
+++ b/drivers/isdn/hardware/eicon/debug.c
@@ -1198,7 +1198,7 @@ int SuperTraceASSIGN (void* AdapterHandle, byte* data) {
         pC->xbuffer[5] = (byte)(rx_dma_magic >>  8);
         pC->xbuffer[6] = (byte)(rx_dma_magic >> 16);
         pC->xbuffer[7] = (byte)(rx_dma_magic >> 24);
-        pC->xbuffer[8] = (byte)DIVA_MAX_MANAGEMENT_TRANSFER_SIZE;
+	pC->xbuffer[8] = (byte)(DIVA_MAX_MANAGEMENT_TRANSFER_SIZE & 0xFF);
         pC->xbuffer[9] = (byte)(DIVA_MAX_MANAGEMENT_TRANSFER_SIZE >> 8);
         pC->xbuffer[10] = 0;
 

