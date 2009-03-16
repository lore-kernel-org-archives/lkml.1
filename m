Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZCPKfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZCPKfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZCPKfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:35:41 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39199 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbZCPKfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:35:41 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] Char: isicom, fix build warning
Date: Mon, 16 Mar 2009 11:34:25 +0100
Message-Id: <1237199665-10675-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <1237199665-10675-1-git-send-email-jirislaby@gmail.com>
References: <1237199665-10675-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this:
isicom.c: In function `isicom_probe':
isicom.c:1587: warning: `signature' may be used uninitialized in this function
by uninitialized_var(), because if the signature is not initialized in
reset_card(), we won't use it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/isicom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 855f375..2be72e6 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1584,7 +1584,7 @@ static unsigned int card_count;
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int signature, index;
+	unsigned int uninitialized_var(signature), index;
 	int retval = -EPERM;
 	struct isi_board *board = NULL;
 
-- 
1.6.2

