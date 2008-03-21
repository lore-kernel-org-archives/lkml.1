Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbYCUWqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbYCUWqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762255AbYCUWps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:45:48 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34673 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762039AbYCUWpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:45:47 -0400
Message-Id: <20080321224343.661991473@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 17/76] ub: fix up the conversion to sg_init_table()
Content-Disposition: inline; filename=ub-fix-up-the-conversion-to-sg_init_table.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Pete Zaitcev <zaitcev@redhat.com>

---
 drivers/block/ub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -657,7 +657,6 @@ static int ub_request_fn_1(struct ub_lun
 	if ((cmd = ub_get_cmd(lun)) == NULL)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
-	sg_init_table(cmd->sgv, UB_MAX_REQ_SG);
 
 	blkdev_dequeue_request(rq);
 
@@ -668,6 +667,7 @@ static int ub_request_fn_1(struct ub_lun
 	/*
 	 * get scatterlist from block layer
 	 */
+	sg_init_table(&urq->sgv[0], UB_MAX_REQ_SG);
 	n_elem = blk_rq_map_sg(lun->disk->queue, rq, &urq->sgv[0]);
 	if (n_elem < 0) {
 		/* Impossible, because blk_rq_map_sg should not hit ENOMEM. */

-- 
