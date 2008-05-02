Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbYEBDxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbYEBDxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYEBDwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:62619 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290AbYEBDwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=H9uZVMWBDQYwbUT0lCjzP/ZcVS9lfO86UvUFRfzNvqDpytFwNMNInRMdH0nKMaGrZt79tPdzFxRnpzG1aFSPavfUWkzdTCkqBd1ytCfFLhYFBQfEqAvHfUXDaAr3XfdcA+TxJh8MgFHy3YMhBOSTCPiu89ndwVM3C7PYeTlfHbo=
Subject: [PATCH 2/8] ide: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:55 -0700
Message-Id: <1209700376.22362.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ide/ide-tape.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1e1f263..d285da5 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -538,7 +538,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 	if (pc->flags & PC_FLAG_DMA_ERROR) {
 		pc->xferred = pc->req_xfer -
 			tape->blk_size *
-			be32_to_cpu(get_unaligned((u32 *)&sense[3]));
+			get_unaligned_be32(&sense[3]);
 		idetape_update_buffers(pc);
 	}
 
-- 
1.5.5.1.350.gbbbf


