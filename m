Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbZKHU04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbZKHU04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZKHU0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:26:54 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754621AbZKHU0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:26:20 -0500
Subject: [PATCH 19/20] scsi/sym53c416: No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       lw_linux@hotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:31 -0300
Message-ID: <1257711451.4759.125.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

---
 drivers/scsi/sym53c416.c |    6 +++---
 drivers/scsi/sym53c416.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index e5c369b..accdf6c 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -225,7 +225,7 @@ static host hosts[MAXHOSTS] = {
 
 static int host_index = 0;
 static char info[120];
-static Scsi_Cmnd *current_command = NULL;
+static struct scsi_cmnd *current_command = NULL;
 static int fastpio = 1;
 
 static int probeaddrs[] = {0x200, 0x220, 0x240, 0};
@@ -734,7 +734,7 @@ const char *sym53c416_info(struct Scsi_Host *SChost)
 	return info;
 }
 
-int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+int sym53c416_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	int base;
 	unsigned long flags = 0;
@@ -761,7 +761,7 @@ int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	return 0;
 }
 
-static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
+static int sym53c416_host_reset(struct scsi_cmnd *SCpnt)
 {
 	int base;
 	int scsi_id = -1;	
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
index 77860d0..a6a89fd 100644
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -25,8 +25,8 @@
 static int sym53c416_detect(struct scsi_host_template *);
 static const char *sym53c416_info(struct Scsi_Host *);
 static int sym53c416_release(struct Scsi_Host *);
-static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int sym53c416_host_reset(Scsi_Cmnd *);
+static int sym53c416_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
+static int sym53c416_host_reset(struct scsi_cmnd *);
 static int sym53c416_bios_param(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 static void sym53c416_setup(char *str, int *ints);



