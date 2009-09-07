Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZIGGX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZIGGX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758941AbZIGGX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:23:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35084 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903AbZIGGX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:23:56 -0400
Date: Mon, 7 Sep 2009 16:23:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kashyap@vger.kernel.org, Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the trivial tree with the scsi tree
Message-Id: <20090907162349.3b3337e3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/scsi/mpt2sas/mpt2sas_scsih.c between commit
155dd4c763694222c125e65438d823f58ea653bc ("[SCSI] mpt2sas: Prevent
sending command to FW while Host Reset") from the scsi tree and commit
8eaa1cbfd596aeb0d2fec7706faccab42eb4bf62 ("trivial: fix typos "man[ae]g?
ment" -> "management"") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.

Jiri, maybe the scsi part of that trivial patch could be sent to the scsi
maintainer.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 774b345,e849fc7..0000000
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@@ -2584,11 -2633,14 +2584,11 @@@ _scsih_qcmd(struct scsi_cmnd *scmd, voi
  		return 0;
  	}
  
- 	/* see if we are busy with task managment stuff */
+ 	/* see if we are busy with task management stuff */
 -	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 -	if (sas_target_priv_data->tm_busy ||
 -	    ioc->shost_recovery || ioc->ioc_link_reset_in_progress) {
 -		spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 +	if (sas_target_priv_data->tm_busy)
 +		return SCSI_MLQUEUE_DEVICE_BUSY;
 +	else if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
  		return SCSI_MLQUEUE_HOST_BUSY;
 -	}
 -	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
  
  	if (scmd->sc_data_direction == DMA_FROM_DEVICE)
  		mpi_control = MPI2_SCSIIO_CONTROL_READ;
