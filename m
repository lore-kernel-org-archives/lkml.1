Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbZIFVKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbZIFVKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 17:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758554AbZIFVKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 17:10:09 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60203 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbZIFVKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 17:10:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] Char: riscom8, fix tty refcnt
Date: Sun,  6 Sep 2009 23:10:09 +0200
Message-Id: <1252271410-26080-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a tty refcnt leak on one fail path in rc_transmit.
Fix that by jumping to the 'out' label.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/riscom8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 3c7cf2c..3cfa22d 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -467,7 +467,7 @@ static void rc_transmit(struct riscom_board const *bp)
 			rc_out(bp, CD180_CCR, CCR_CORCHG2);
 			port->break_length = 0;
 		}
-		return;
+		goto out;
 	}
 
 	count = CD180_NFIFO;
-- 
1.6.4.2

