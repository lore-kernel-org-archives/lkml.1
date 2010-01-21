Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618Ab0AUE3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0AUE3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214Ab0AUE3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:29:36 -0500
Received: from havoc.gtf.org ([69.61.125.42]:52638 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab0AUE3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:29:33 -0500
Date: Wed, 20 Jan 2010 23:29:31 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20100121042931.GA17744@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-eh.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

Tejun Heo (1):
      libata: retry FS IOs even if it has failed with AC_ERR_INVALID

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0ea97c9..9f6cfac 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2028,8 +2028,9 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 			qc->err_mask &= ~(AC_ERR_DEV | AC_ERR_OTHER);
 
 		/* determine whether the command is worth retrying */
-		if (!(qc->err_mask & AC_ERR_INVALID) &&
-		    ((qc->flags & ATA_QCFLAG_IO) || qc->err_mask != AC_ERR_DEV))
+		if (qc->flags & ATA_QCFLAG_IO ||
+		    (!(qc->err_mask & AC_ERR_INVALID) &&
+		     qc->err_mask != AC_ERR_DEV))
 			qc->flags |= ATA_QCFLAG_RETRY;
 
 		/* accumulate error info */
