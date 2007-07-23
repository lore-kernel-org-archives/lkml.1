Return-Path: <linux-kernel-owner+w=401wt.eu-S1763769AbXGWNYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763769AbXGWNYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXGWNYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:24:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42046 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756228AbXGWNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:24:45 -0400
Date: Mon, 23 Jul 2007 15:24:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Eric.Moore@lsi.com
Cc: mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: drivers/message/fusion/mptscsih.c: inconsequent NULL checking
Message-ID: <20070723132410.GI26212@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted the following inconsequent NULL checking in 
drivers/message/fusion/mptscsih.c:

<--  snip  -->

...
int
mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
{
...
        if (vdev
            && (vdev->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
            && (SCpnt->device->tagged_supported)) { 
                scsictl = scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
        } else {
                scsictl = scsidir | MPI_SCSIIO_CONTROL_UNTAGGED; 
        }
 
        /* Use the above information to set up the message frame
         */
        pScsiReq->TargetID = (u8) vdev->vtarget->id;
...

<--  snip  -->

"vdev" is first checked but later dereferenced unconditionally.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

