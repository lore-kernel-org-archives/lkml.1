Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbYISRiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbYISRiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYISRiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:38:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:24427 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYISRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:38:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:user-agent:from;
        b=J7ojLV5dfZSQHs0RoSfGpzmUblz+JDiB+GnLpV2jDQYKudbKrXEGIOfi3cvb3brDwo
         PTWFfXddozseO5xQkPloVG5a05AhH8xEdpDI1QX2FdufSksw5z8/uMDVjRVTGem6vtEv
         zPLxn2itwhmuWiVz4SqvgwDPgW0ZBkFNa64ME=
Date: Fri, 19 Sep 2008 19:38:03 +0200
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ide-cd: fix debug printk
Message-ID: <20080919173803.GA21355@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

please apply.
---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Fri, 19 Sep 2008 19:30:46 +0200
Subject: [PATCH] ide-cd: fix debug printk

failed_command can be NULL so check it before accessing it.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3fdf660..5ed925d 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -221,6 +221,8 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	struct cdrom_info *info		= drive->driver_data;
 	struct request *rq		= &info->request_sense_request;
 
+	ide_debug_log(IDE_DBG_SENSE, "Call %s\n", __func__);
+
 	if (sense == NULL)
 		sense = &info->sense_data;
 
@@ -240,8 +242,9 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 	/* NOTE! Save the failed command in "rq->buffer" */
 	rq->buffer = (void *) failed_command;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s, failed_cmd: 0x%x\n", __func__,
-		      failed_command->cmd[0]);
+	if (failed_command)
+		ide_debug_log(IDE_DBG_SENSE, "failed_cmd: 0x%x\n",
+			      failed_command->cmd[0]);
 
 	ide_do_drive_cmd(drive, rq);
 }
-- 
1.5.5.1

-- 
Regards/Gruss,
    Boris.
