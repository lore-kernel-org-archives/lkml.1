Return-Path: <linux-kernel-owner+w=401wt.eu-S1750968AbZIGGxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968AbZIGGxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 02:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbZIGGxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 02:53:23 -0400
Received: from exprod7og127.obsmtp.com ([64.18.2.210]:35190 "EHLO
	exprod7og127.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZIGGxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 02:53:22 -0400
From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jiri Kosina <jkosina@suse.cz>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kashyap@mail2.lsil.com" <Kashyap@mail2.lsil.com>,
       James Bottomley <James.Bottomley@suse.de>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Date: Mon, 7 Sep 2009 12:22:55 +0530
Subject: RE: linux-next: manual merge of the trivial tree with the scsi tree
Thread-Topic: linux-next: manual merge of the trivial tree with the scsi tree
Thread-Index: Acovg9YKCt3pR8W4SZ+9B8t8Fgg5eQAA2/Wg
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C8EAE09B1@inbmail01.lsi.com>
References: <20090907162349.3b3337e3.sfr@canb.auug.org.au>
In-Reply-To: <20090907162349.3b3337e3.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

If you are waiting for ACK, then please carry the fix with my ACK signature.

Thanks,
Kashyap

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Monday, September 07, 2009 11:54 AM
To: Jiri Kosina
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Kashyap@mail2.lsil.com; Desai, Kashyap; James Bottomley; Uwe Kleine-Koenig
Subject: linux-next: manual merge of the trivial tree with the scsi tree

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
