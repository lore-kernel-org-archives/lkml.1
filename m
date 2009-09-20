Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZITJoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZITJoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 05:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbZITJoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 05:44:18 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47615 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbZITJoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 05:44:17 -0400
Date: Sun, 20 Sep 2009 11:44:18 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/scsi/qla2xxx: harmonize the use of constants
Message-ID: <Pine.LNX.4.64.0909201143440.14236@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The fields out_mb and in_mb are elsewhere combined with the constant MBX_0
rather than BIT_0.  These have the same value so there is no change in the
behavior of the code.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/qla2xxx/qla_mbx.c      |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index b6202fe..6a621e6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -91,7 +91,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		if (IS_QLA2200(ha) && cnt == 8)
 			optr =
 			    (uint16_t __iomem *)MAILBOX_REG(ha, &reg->isp, 8);
-		if (mboxes & BIT_0)
+		if (mboxes & MBX_0)
 			WRT_REG_WORD(optr, *iptr);
 
 		mboxes >>= 1;
@@ -179,7 +179,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		iptr = (uint16_t *)&ha->mailbox_out[0];
 		mboxes = mcp->in_mb;
 		for (cnt = 0; cnt < ha->mbx_count; cnt++) {
-			if (mboxes & BIT_0)
+			if (mboxes & MBX_0)
 				*iptr2 = *iptr;
 
 			mboxes >>= 1;
