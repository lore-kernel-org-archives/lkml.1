Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYBJKG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYBJKG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 05:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYBJKGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 05:06:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:48732 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbYBJKGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 05:06:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=pcfrsqPKm7Kqiue9Y8MzzdkB5BQG1fDNBMb8OkjnzsNgqmZDpJHvrd2bxBXi816uyzG0FlCJSwr90fLc414KxMzHdt8LJLr7cboIOmWZpnKOMkChXl+/UwQc00DeO/Ag9JOSV2zIjPe4b7DHGKlWBXXmzM+zPsfQPyZws5pzraQ=
Date: Sun, 10 Feb 2008 11:06:08 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: netdev@vger.kernel.org, linux-driver@qlogic.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH resend] qla3xxx: convert byte order of constant instead of
	variable
Message-ID: <20080210100546.GA6737@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert byte order of constant instead of variable
which can be done at compile time (vs run time)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/net/qla3xxx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index a6aeb9d..b7f7b22 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -2472,8 +2472,7 @@ static int ql_send_map(struct ql3_adapter *qdev,
 
 	if (seg_cnt == 1) {
 		/* Terminate the last segment. */
-		oal_entry->len =
-		    cpu_to_le32(le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY);
+		oal_entry->len |= cpu_to_le32(OAL_LAST_ENTRY);
 	} else {
 		oal = tx_cb->oal;
 		for (completed_segs=0; completed_segs<frag_cnt; completed_segs++,seg++) {
@@ -2530,8 +2529,7 @@ static int ql_send_map(struct ql3_adapter *qdev,
 					  frag->size);
 		}
 		/* Terminate the last segment. */
-		oal_entry->len =
-		    cpu_to_le32(le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY);
+		oal_entry->len |= cpu_to_le32(OAL_LAST_ENTRY);
 	}
 
 	return NETDEV_TX_OK;
-- 
1.5.3.7

