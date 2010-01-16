Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab0APP7H (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583Ab0APP7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:59:04 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44183 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab0APP7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:59:00 -0500
Date: Sat, 16 Jan 2010 16:58:58 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Jing Huang <huangj@brocade.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 5/9] drivers/scsi: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161658410.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable bfa_itnim is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/bfa/bfad_im.c          |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f788c2a..37b0fa1 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -243,9 +243,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
 
-	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
 		BFA_DEV_PRINTF(bfad, BFA_ERR,
