Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbYIYHvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbYIYHvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYIYHvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:51:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:35836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYIYHvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:user-agent:from;
        b=ML4aqiQQf/T2M8ZaNhU+KjF4/+8NoC0r6lTn+T4JlrrJONauL8a4Qhwd4c1aCPf4/D
         pcWsQnBkgpkdI5BHkLiYVb/vclnYVkntHPMGOBx9dNcBGKpCkgGSyB7aaoJr3hhkqZdW
         jQFYaftSPmesZcF81RVGppQDOi6L4nYY2QghE=
Date: Thu, 25 Sep 2008 09:51:33 +0200
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-cd: fix another NULL ptr in debug statement
Message-ID: <20080925075133.GC13100@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here's another null ptr fix in the debugging code. I'll be auditing all the
debug fragments in case I've missed some.

---
From: Borislav Petkov <petkovbb@gmail.com>
Date: Thu, 25 Sep 2008 09:36:26 +0200
Subject: [PATCH] ide-cd: fix another NULL ptr in debug statement

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 5ed925d..c830817 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -166,10 +166,13 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 	unsigned long bio_sectors;
 	struct cdrom_info *info = drive->driver_data;
 
-	ide_debug_log(IDE_DBG_SENSE, "Call %s, failed cmd: 0x%x, "
-		      "error_code: 0x%x, sense_key: 0x%x\n",
-		      __func__, failed_command->cmd[0], sense->error_code,
-		      sense->sense_key);
+	ide_debug_log(IDE_DBG_SENSE, "Call %s, error_code: 0x%x, "
+			"sense_key: 0x%x\n", __func__, sense->error_code,
+			sense->sense_key);
+
+	if (failed_command)
+		ide_debug_log(IDE_DBG_SENSE, "%s: failed cmd: 0x%x\n",
+				__func__, failed_command->cmd[0]);
 
 	if (!cdrom_log_sense(drive, failed_command, sense))
 		return;
-- 
1.5.5.4

-- 
Regards/Gruss,
    Boris.
