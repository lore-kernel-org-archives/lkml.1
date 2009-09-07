Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbZIGPKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbZIGPKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZIGPKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:10:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbZIGPKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:10:34 -0400
Date: Mon, 7 Sep 2009 17:10:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Kashyap@suse.de,
       Desai <kashyap.desai@lsi.com>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: Re: linux-next: manual merge of the trivial tree with the scsi
 tree
In-Reply-To: <20090907162349.3b3337e3.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0909071708400.23856@wotan.suse.de>
References: <20090907162349.3b3337e3.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Stephen Rothwell wrote:

> Hi Jiri,
> 
> Today's linux-next merge of the trivial tree got a conflict in
> drivers/scsi/mpt2sas/mpt2sas_scsih.c between commit
> 155dd4c763694222c125e65438d823f58ea653bc ("[SCSI] mpt2sas: Prevent
> sending command to FW while Host Reset") from the scsi tree and commit
> 8eaa1cbfd596aeb0d2fec7706faccab42eb4bf62 ("trivial: fix typos "man[ae]g?
> ment" -> "management"") from the trivial tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> 
> Jiri, maybe the scsi part of that trivial patch could be sent to the scsi
> maintainer.

Sure, here we go. James, could you please apply? (I have already dropped 
it from trivial queue). Thanks.




From: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: trivial: fix typos "man[ae]g?ment" -> "management"

Signed-off-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 286c185..fa85253 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -434,7 +434,7 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
  * @ioc_reset_in_progress: host reset in progress
  * @ioc_reset_in_progress_lock:
  * @ioc_link_reset_in_progress: phy/hard reset in progress
- * @ignore_loginfos: ignore loginfos during task managment
+ * @ignore_loginfos: ignore loginfos during task management
  * @remove_host: flag for when driver unloads, to avoid sending dev resets
  * @wait_for_port_enable_to_complete:
  * @msix_enable: flag indicating msix is enabled
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 2a01a5f..e849fc7 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2633,7 +2633,7 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		return 0;
 	}
 
-	/* see if we are busy with task managment stuff */
+	/* see if we are busy with task management stuff */
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	if (sas_target_priv_data->tm_busy ||
 	    ioc->shost_recovery || ioc->ioc_link_reset_in_progress) {
@@ -5857,7 +5857,7 @@ _scsih_init(void)
 	 /* queuecommand callback hander */
 	scsi_io_cb_idx = mpt2sas_base_register_callback_handler(_scsih_io_done);
 
-	/* task managment callback handler */
+	/* task management callback handler */
 	tm_cb_idx = mpt2sas_base_register_callback_handler(_scsih_tm_done);
 
 	/* base internal commands callback handler */

