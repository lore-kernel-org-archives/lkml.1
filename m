Return-Path: <linux-kernel-owner+w=401wt.eu-S1753717AbZD1Dxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbZD1Dxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbZD1Dwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:52:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:46127 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525AbZD1Dwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:52:37 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, donari75@gmail.com,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/3] mg_disk: fix CONFIG_LBD=y warning
Date: Tue, 28 Apr 2009 12:52:18 +0900
Message-Id: <1240890740-3462-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240890740-3462-1-git-send-email-tj@kernel.org>
References: <1240890740-3462-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 03:52:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

drivers/block/mg_disk.c: In function ‘mg_dump_status’:
drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
argument 2 has type ‘sector_t’

[ Impact: kill build warning ]

Cc: unsik Kim <donari75@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/mg_disk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index d3e72ad..f389835 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -79,7 +79,7 @@ static void mg_dump_status(const char *msg, unsigned int stat,
 			if (host->breq) {
 				req = elv_next_request(host->breq);
 				if (req)
-					printk(", sector=%ld", req->sector);
+					printk(", sector=%u", (u32)req->sector);
 			}
 
 		}
-- 
1.6.0.2

