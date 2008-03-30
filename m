Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbYC3JnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbYC3JnG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 05:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbYC3Jmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 05:42:55 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:50300 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYC3Jmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 05:42:54 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] Char: moxa, fix compiler warning
Date: Sun, 30 Mar 2008 10:42:29 +0200
Message-Id: <1206866549-13784-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On CONFIG_MOXA_INTELLIO=y, this warning was emitted:
drivers/char/moxa.c: In function ‘moxa_init’:
drivers/char/moxa.c:1000: warning: unused variable ‘i’

Move it into the conditional section where is only used.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 57616c1..1ab9517 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -997,7 +997,7 @@ static struct pci_driver moxa_pci_driver = {
 
 static int __init moxa_init(void)
 {
-	unsigned int i, isabrds = 0;
+	unsigned int isabrds = 0;
 	int retval = 0;
 
 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
@@ -1029,6 +1029,7 @@ static int __init moxa_init(void)
 #ifdef MODULE
 	{
 	struct moxa_board_conf *brd = moxa_boards;
+	unsigned int i;
 	for (i = 0; i < MAX_BOARDS; i++) {
 		if (!baseaddr[i])
 			break;
-- 
1.5.4.4

