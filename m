Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZGRJz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZGRJz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 05:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbZGRJzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 05:55:25 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36655 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZGRJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 05:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UY2NGq97RSYSGouGpKREoqBLJ6YrQuDF4QYJUYoO1PkxEgniiQdQarLPNwNMTDPqBo
         aDBjuPPisvt9MihtR7fVJqtJtkHxz2L0seTKr5p50mSNplltPfPuWREry6z80opwbqko
         lKx2oBQSfN76iTX9S+856vx26fjGz9UWRpITQ=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <davem@davemloft.net>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark de Wever <koraq@xs4all.nl>
Subject: [PATCH 1/3] ide-tape: fix debug call
Date: Sat, 18 Jul 2009 11:55:15 +0200
Message-Id: <1247910917-5237-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
References: <1247910917-5237-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark de Wever <koraq@xs4all.nl>

This error only occurs when IDETAPE_DEBUG_LOG is enabled.

Signed-off-by: Mark de Wever <koraq@xs4all.nl>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 013dc59..60d5c41 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -583,7 +583,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 	struct ide_cmd cmd;
 	u8 stat;
 
-	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
+	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n",
 		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
 
 	BUG_ON(!(blk_special_request(rq) || blk_sense_request(rq)));
-- 
1.6.3.3

