Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYFVOVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYFVOVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754852AbYFVOUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:20:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45085 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYFVOUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:20:40 -0400
To: mchehab@infradead.org
Subject: [PATCH] pluto_set_dma_addr() fix
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQp-00023z-JH@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:20:39 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


bogus cpu_to_le32() when passing dma address to hardware
via writel() - writel() converts itself.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/pluto2/pluto2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 960ed57..1360403 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -234,7 +234,7 @@ static void pluto_reset_ts(struct pluto *pluto, int reenable)
 
 static void pluto_set_dma_addr(struct pluto *pluto)
 {
-	pluto_writereg(pluto, REG_PCAR, cpu_to_le32(pluto->dma_addr));
+	pluto_writereg(pluto, REG_PCAR, pluto->dma_addr);
 }
 
 static int __devinit pluto_dma_map(struct pluto *pluto)
-- 
1.5.3.GIT


