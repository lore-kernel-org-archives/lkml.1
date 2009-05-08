Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbZEHOCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbZEHOCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbZEHOB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:01:29 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58241 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756701AbZEHOB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:01:27 -0400
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jim Paris <jim@jtan.com>
Subject: [PATCH 01/15] ps3vram: Fix error path (return -EIO) for short read/write
Date: Fri,  8 May 2009 16:01:10 +0200
Message-Id: <1241791284-11490-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1241791284-11490-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jim Paris <jim@jtan.com>
---
 drivers/block/ps3vram.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 8eddef3..2e79d2c 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -585,6 +585,7 @@ static int ps3vram_make_request(struct request_queue *q, struct bio *bio)
 
 		if (retlen != len) {
 			dev_err(&dev->core, "Short %s\n", op);
+			error = -EIO;
 			goto out;
 		}
 
-- 
1.6.2.4

