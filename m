Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbXKAGca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbXKAGca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 02:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXKAGcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 02:32:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47085 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810AbXKAGcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 02:32:21 -0400
Date: Thu, 1 Nov 2007 17:32:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <aacraid@adaptec.com>
Cc: <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] aacraid: don't assign cpu_to_le32(constant) to u8
Message-Id: <20071101173221.2e1fea42.sfr@canb.auug.org.au>
In-Reply-To: <20071031150216.88cecc21.sfr@canb.auug.org.au>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed on PowerPC allmod config build:

drivers/scsi/aacraid/commsup.c:1342: warning: large integer implicitly truncated to unsigned type
drivers/scsi/aacraid/commsup.c:1343: warning: large integer implicitly truncated to unsigned type
drivers/scsi/aacraid/commsup.c:1344: warning: large integer implicitly truncated to unsigned type

Also fix some whitespace on the changed lines.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/aacraid/commsup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

This version just fixes a couple of whitespace anomolies on the lines I
changed.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 240a0bb..3c2dbc0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aac)
 			aif = (struct aac_aifcmd *)hw_fib->data;
 			aif->command = cpu_to_le32(AifCmdEventNotify);
 		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
-		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
-			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
-		 	aif->data[2] = cpu_to_le32(AifHighPriority);
+			aif->data[0] = AifEnExpEvent;
+			aif->data[1] = AifExeFirmwarePanic;
+			aif->data[2] = AifHighPriority;
 			aif->data[3] = cpu_to_le32(BlinkLED);
 
 			/*
-- 
1.5.3.4

