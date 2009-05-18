Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbZERH74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbZERH74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 03:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZERH7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 03:59:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40381 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZERH7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 03:59:46 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Subject: [PATCH] pcmcia: yenta: add missing __devexit marking
Date: Mon, 18 May 2009 03:59:45 -0400
Message-Id: <1242633585-16513-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove member of the pci_driver yenta_cardbus_driver uses
__devexit_p(), so the remove function itself should be marked with
__devexit.  Even more so considering the probe function is marked
with __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
CC: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
---
 drivers/pcmcia/yenta_socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 3ecd7c9..2ed1e15 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -717,7 +717,7 @@ static void yenta_free_resources(struct yenta_socket *socket)
 /*
  * Close it down - release our resources and go home..
  */
-static void yenta_close(struct pci_dev *dev)
+static void __devexit yenta_close(struct pci_dev *dev)
 {
 	struct yenta_socket *sock = pci_get_drvdata(dev);
 
-- 
1.6.3

