Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbYHHQjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbYHHQjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbYHHQgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:23 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49907 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbYHHQgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:21 -0400
Date: Fri, 8 Aug 2008 19:34:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com, petkovbb@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [8/17] ide-cd: use bcd2bin/bin2bcd
Message-ID: <20080808163446.GO14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes ide-cd to use the new bcd2bin/bin2bcd functions 
instead of the obsolete BCD2BIN/BIN2BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/ide/ide-cd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

71c0e7b9b6349129f4f810314598b6e76f1448d7 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index e617cf0..a8e3ad2 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1270,9 +1270,9 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
  */
 static void msf_from_bcd(struct atapi_msf *msf)
 {
-	msf->minute = BCD2BIN(msf->minute);
-	msf->second = BCD2BIN(msf->second);
-	msf->frame  = BCD2BIN(msf->frame);
+	msf->minute = bcd2bin(msf->minute);
+	msf->second = bcd2bin(msf->second);
+	msf->frame  = bcd2bin(msf->frame);
 }
 
 int cdrom_check_status(ide_drive_t *drive, struct request_sense *sense)
@@ -1411,8 +1411,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 		return stat;
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
+		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
+		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	ntracks = toc->hdr.last_track - toc->hdr.first_track + 1;
@@ -1452,8 +1452,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 			return stat;
 
 		if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-			toc->hdr.first_track = (u8)BIN2BCD(CDROM_LEADOUT);
-			toc->hdr.last_track = (u8)BIN2BCD(CDROM_LEADOUT);
+			toc->hdr.first_track = (u8)bin2bcd(CDROM_LEADOUT);
+			toc->hdr.last_track = (u8)bin2bcd(CDROM_LEADOUT);
 		} else {
 			toc->hdr.first_track = CDROM_LEADOUT;
 			toc->hdr.last_track = CDROM_LEADOUT;
@@ -1466,14 +1466,14 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	toc->hdr.toc_length = be16_to_cpu(toc->hdr.toc_length);
 
 	if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD) {
-		toc->hdr.first_track = BCD2BIN(toc->hdr.first_track);
-		toc->hdr.last_track  = BCD2BIN(toc->hdr.last_track);
+		toc->hdr.first_track = bcd2bin(toc->hdr.first_track);
+		toc->hdr.last_track  = bcd2bin(toc->hdr.last_track);
 	}
 
 	for (i = 0; i <= ntracks; i++) {
 		if (drive->atapi_flags & IDE_AFLAG_TOCADDR_AS_BCD) {
 			if (drive->atapi_flags & IDE_AFLAG_TOCTRACKS_AS_BCD)
-				toc->ent[i].track = BCD2BIN(toc->ent[i].track);
+				toc->ent[i].track = bcd2bin(toc->ent[i].track);
 			msf_from_bcd(&toc->ent[i].addr.msf);
 		}
 		toc->ent[i].addr.lba = msf_to_lba(toc->ent[i].addr.msf.minute,
