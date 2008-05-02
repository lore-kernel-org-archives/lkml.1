Return-Path: <linux-kernel-owner+w=401wt.eu-S965586AbYEBTIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965586AbYEBTIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964883AbYEBTFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:39016 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964826AbYEBTFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=flzk39Ml96ZZVwfl0si9hzBf75af5Gel53yG8BD9YEyHW+y4AgqdHLt+SumMf/tFC3HkOJAfnVIgtgIvIcRl/SIRyyGGzY38AltVu5GM7uV/xf/m2a+Qmo5hwbeyEtCfjUq5mXGG3a4Q6/zJY1cf6ts2eyBBy4U4gvsUrn7rbuY=
Subject: [PATCH 02/14] ide: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:54 -0700
Message-Id: <1209755155.26173.68.camel@brick>
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


