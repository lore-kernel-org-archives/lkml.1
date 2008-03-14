Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYCNFWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYCNFWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758037AbYCNFVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:21:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24244 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbYCNFVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aEGiw+TNwApacfZ8EiW5xvzH+b5TGNwS/RkWZEUv6fFeViINPWOHICjDyBd659SvQDWiWKxnkZJc1p+i78HnFiCop3iTm29tg/YCyAD9BGqTqZFPhYjkVR2gjxlHfq3D9z3P1qJvzqx1U84Y97NuImUt1M1juYxjAJxbaobdvMY=
Subject: [PATCH 08/10] ide-tape: use clamp_t() rather than nested
	min_t()/max_t()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:21:22 -0700
Message-Id: <1205472082.19712.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ide/ide-tape.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 43e0e05..8a70389 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3564,9 +3564,8 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	 * Ensure that the number we got makes sense; limit it within
 	 * IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
 	 */
-	tape->best_dsc_rw_freq = max_t(unsigned long,
-				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
-				IDETAPE_DSC_RW_MIN);
+	tape->best_dsc_rw_freq = clamp_t(unsigned long, t, IDETAPE_DSC_RW_MIN,
+					 IDETAPE_DSC_RW_MAX);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
 		"%dkB pipeline, %lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
-- 
1.5.4.4.653.g7cf1e


