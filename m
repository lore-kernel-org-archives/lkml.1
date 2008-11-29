Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYK2VfC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYK2VfC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:35:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYK2Vex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:34:53 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:45859 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYK2Vex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:34:53 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: chas@cmf.nrl.navy.mil
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] ATM: horizon, fix hrz_probe fail path
Date: Sat, 29 Nov 2008 22:34:25 +0100
Message-Id: <1227994465-20220-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fail path in hrz_probe omitted device disable. Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/atm/horizon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 6154123..6b969f8 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2705,7 +2705,7 @@ static int __devinit hrz_probe(struct pci_dev *pci_dev, const struct pci_device_
 
 	/* XXX DEV_LABEL is a guess */
 	if (!request_region(iobase, HRZ_IO_EXTENT, DEV_LABEL)) {
-		return -EINVAL;
+		err = -EINVAL;
 		goto out_disable;
 	}
 
-- 
1.6.0.4

