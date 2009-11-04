Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbZKDSM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbZKDSM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:12:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757516AbZKDSM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:12:57 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:27954 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbZKDSM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:12:56 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -2nd repost 2/4] SCSI: remove unnecessary NULL test
Date: Wed, 4 Nov 2009 10:18:42 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33406BFD213@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -2nd repost 2/4] SCSI: remove unnecessary NULL test
Thread-Index: AcpdapMEJ81W+IECT96DWBNFl74W+wAEIYHw
References: <1257351321-8281-1-git-send-email-jirislaby@gmail.com> <1257351321-8281-2-git-send-email-jirislaby@gmail.com>
From: "Karen Xie" <kxie@chelsio.com>
To: "Jiri Slaby" <jirislaby@gmail.com>, <James.Bottomley@suse.de>
Cc: <aacraid@adaptec.com>, <james.smart@emulex.com>,
       <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the check is not necessary.

Thanks,
Karen

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jiri Slaby
Sent: Wednesday, November 04, 2009 8:15 AM
To: James.Bottomley@suse.de
Cc: aacraid@adaptec.com; james.smart@emulex.com;
linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Jiri Slaby
Subject: [PATCH -2nd repost 2/4] SCSI: remove unnecessary NULL test

Stanse found that c3cn is poked many times around in
cxgb3i_conn_pdu_ready, there is no need to check if it is NULL.

Remove the test.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/cxgb3i/cxgb3i_pdu.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 7091050..64bbc28 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -461,10 +461,8 @@ void cxgb3i_conn_pdu_ready(struct s3_conn *c3cn)
 		skb = skb_peek(&c3cn->receive_queue);
 	}
 	read_unlock(&c3cn->callback_lock);
-	if (c3cn) {
-		c3cn->copied_seq += read;
-		cxgb3i_c3cn_rx_credits(c3cn, read);
-	}
+	c3cn->copied_seq += read;
+	cxgb3i_c3cn_rx_credits(c3cn, read);
 	conn->rxdata_octets += read;
 
 	if (err) {
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
