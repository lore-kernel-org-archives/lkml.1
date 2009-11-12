Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZKLStl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZKLStl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZKLSsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:00 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:33310 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZKLSr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:47:57 -0500
Subject: [PATCH 03/11] cciss: Retry driver initiated cmds with unit attention
	condition
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:25 -0600
Message-ID: <20091112184925.23389.54971.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss:  Retry driver initiated cmds with unit attention condition

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 81c2187..429b9b6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2531,6 +2531,8 @@ static int check_target_status(ctlr_info_t *h, CommandList_struct *c)
 		case 0: return IO_OK; /* no sense */
 		case 1: return IO_OK; /* recovered error */
 		default:
+			if (check_for_unit_attention(h, c))
+				return IO_NEEDS_RETRY;
 			printk(KERN_WARNING "cciss%d: cmd 0x%02x "
 				"check condition, sense key = 0x%02x\n",
 				h->ctlr, c->Request.CDB[0],

