Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYBZHv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYBZHv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbYBZHuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:50:39 -0500
Received: from hu-out-0506.google.com ([72.14.214.224]:43369 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761235AbYBZHue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:50:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=BW/C7Kd5ucmLrkYJJ49OsNjGYYiAyQwODF8XLY5Zn62ij3obSKekxQQYv5fgHusZHmD1JTK2SkEUq/RWjWWmc7fVwV4OInwfN+b2/88O96A07IPL/td5DSbpkbZBiaVAZn7vSStRDZKJOFAPHPd/du1E4syvGVOzAEw6tXUtEOU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH] ide-cd: put proc-related functions together under single ifdef
Date: Tue, 26 Feb 2008 08:49:53 +0100
Message-Id: <1204012194-4208-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204012194-4208-1-git-send-email-petkovbb@gmail.com>
References: <1204012194-4208-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 546f436..3600648 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1894,19 +1894,6 @@ int ide_cdrom_setup (ide_drive_t *drive)
 	return 0;
 }
 
-#ifdef CONFIG_IDE_PROC_FS
-static
-sector_t ide_cdrom_capacity (ide_drive_t *drive)
-{
-	unsigned long capacity, sectors_per_frame;
-
-	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
-		return 0;
-
-	return capacity * sectors_per_frame;
-}
-#endif
-
 static void ide_cd_remove(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
@@ -1940,14 +1927,24 @@ static void ide_cd_release(struct kref *kref)
 static int ide_cd_probe(ide_drive_t *);
 
 #ifdef CONFIG_IDE_PROC_FS
-static int proc_idecd_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+static sector_t ide_cdrom_capacity(ide_drive_t *drive)
+{
+	unsigned long capacity, sectors_per_frame;
+
+	if (cdrom_read_capacity(drive, &capacity, &sectors_per_frame, NULL))
+		return 0;
+
+	return capacity * sectors_per_frame;
+}
+
+static int proc_idecd_read_capacity(char *page, char **start, off_t off,
+				int count, int *eof, void *data)
 {
 	ide_drive_t *drive = data;
 	int len;
 
 	len = sprintf(page,"%llu\n", (long long)ide_cdrom_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t idecd_proc[] = {
-- 
1.5.4.1

