Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbZHVSxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbZHVSxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 14:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933188AbZHVSxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 14:53:01 -0400
Received: from server1.wserver.cz ([82.113.45.157]:37433 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933170AbZHVSxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 14:53:00 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] memstick: move dev_dbg
Date: Sat, 22 Aug 2009 20:53:01 +0200
Message-Id: <1250967181-29772-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

id_reg.if_mode might be unitialized when (*mrq)->error is nonzero.
move dev_dbg() inside the if so that we are sure we can use id_reg
values.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/memstick/core/memstick.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index a5b448e..b3bf1c4 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -339,9 +339,9 @@ static int h_memstick_read_dev_id(struct memstick_dev *card,
 			card->id.type = id_reg.type;
 			card->id.category = id_reg.category;
 			card->id.class = id_reg.class;
+			dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
 		}
 		complete(&card->mrq_complete);
-		dev_dbg(&card->dev, "if_mode = %02x\n", id_reg.if_mode);
 		return -EAGAIN;
 	}
 }
-- 
1.6.3.3

