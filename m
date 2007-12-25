Return-Path: <linux-kernel-owner+w=401wt.eu-S1753427AbXLYOrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbXLYOrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 09:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXLYOrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 09:47:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:24063 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbXLYOrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 09:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fgd/ay/UX0LNXwAQoFwrloGIgI9ghDKyoNBA7MsnshJFlDjCmvuJsQs48T5r0bTkjy03r3rCXcZazdzvZMh7xv8V14EKkYghYuOrOets/j8ya2wOg9yy7Zx7c7jGlng9TNVr6Jpew697WUQHlSeefQkyllyIjbEyGeL/Yl/ptzs=
Date: Tue, 25 Dec 2007 15:48:56 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: netdev <netdev@vger.kernel.org>
Cc: linux-driver@qlogic.com, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] qla3xxx: convert byte order of constant instead of variable
Message-ID: <20071225144852.GB24373@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert byte order of constant instead of variable
it will be done at compile time (vs run time)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
---
 drivers/net/qla3xxx.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index a579111..c9f8ba4 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -2497,8 +2497,7 @@ static int ql_send_map(struct ql3_adapter *qdev,

 	if (seg_cnt == 1) {
 		/* Terminate the last segment. */
-		oal_entry->len =
-		    cpu_to_le32(le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY);
+		oal_entry->len |= cpu_to_le32(OAL_LAST_ENTRY);
 	} else {
 		oal = tx_cb->oal;
 		for (completed_segs=0; completed_segs<frag_cnt; completed_segs++,seg++) {
@@ -2555,8 +2554,7 @@ static int ql_send_map(struct ql3_adapter *qdev,
 					  frag->size);
 		}
 		/* Terminate the last segment. */
-		oal_entry->len =
-		    cpu_to_le32(le32_to_cpu(oal_entry->len) | OAL_LAST_ENTRY);
+		oal_entry->len |= cpu_to_le32(OAL_LAST_ENTRY);
 	}

 	return NETDEV_TX_OK;
--
1.5.3.4

