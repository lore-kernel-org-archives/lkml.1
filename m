Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbYCJOpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbYCJOpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 10:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYCJOpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 10:45:15 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:38223 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYCJOpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 10:45:15 -0400
From: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: riscom, fix rc_board indexing
Date: Mon, 10 Mar 2008 15:40:10 +0100
Message-Id: <1205160010-11902-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In riscom8_init_module, rc_board should be indexed by i, not by 0, otherwise
the loop is useless.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/riscom8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b7373c0..ef43b36 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1712,7 +1712,7 @@ static int __init riscom8_init_module (void)
 
 	if (iobase || iobase1 || iobase2 || iobase3) {
 		for(i = 0; i < RC_NBOARD; i++)
-			rc_board[0].base = 0;
+			rc_board[i].base = 0;
 	}
 
 	if (iobase)
-- 
1.5.4.1

