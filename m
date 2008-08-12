Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbYHLOdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbYHLOdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbYHLOcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:32:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYHLOcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:32:53 -0400
Date: Tue, 12 Aug 2008 10:32:51 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, rolandd@cisco.com,
       sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org
Subject: [PATCH] infiniband: change flags from int to long
Message-ID: <alpine.DEB.1.10.0808121030160.18695@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It is a bug to have irq saved flags as an int and not long since
some archs may use more that 32 bits in flags.

(This patch was only compiled tested)

[
 Found by the -rt patch checks. These should now be in mainline,
 but it looks like they may not have been used.
]

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 drivers/infiniband/hw/ipath/ipath_verbs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linus.git/drivers/infiniband/hw/ipath/ipath_verbs.c
===================================================================
--- linus.git.orig/drivers/infiniband/hw/ipath/ipath_verbs.c	2008-08-12 10:23:25.000000000 -0400
+++ linus.git/drivers/infiniband/hw/ipath/ipath_verbs.c	2008-08-12 10:25:24.000000000 -0400
@@ -1021,7 +1021,7 @@ static void sdma_complete(void *cookie, 
 	struct ipath_verbs_txreq *tx = cookie;
 	struct ipath_qp *qp = tx->qp;
 	struct ipath_ibdev *dev = to_idev(qp->ibqp.device);
-	unsigned int flags;
+	unsigned long flags;
 	enum ib_wc_status ibs = status == IPATH_SDMA_TXREQ_S_OK ?
 		IB_WC_SUCCESS : IB_WC_WR_FLUSH_ERR;
 
@@ -1051,7 +1051,7 @@ static void sdma_complete(void *cookie, 
 
 static void decrement_dma_busy(struct ipath_qp *qp)
 {
-	unsigned int flags;
+	unsigned long flags;
 
 	if (atomic_dec_and_test(&qp->s_dma_busy)) {
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -1221,7 +1221,7 @@ static int ipath_verbs_send_pio(struct i
 	unsigned flush_wc;
 	u32 control;
 	int ret;
-	unsigned int flags;
+	unsigned long flags;
 
 	piobuf = ipath_getpiobuf(dd, plen, NULL);
 	if (unlikely(piobuf == NULL)) {

