Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbXLTBnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbXLTBnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXLTBfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:31 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758759AbXLTBek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gvTmIsiqXwEmtlUEwvEMUU0BoRbTEpsk0t3PSEzrIqh5e6oqos/0stEqji9azXek28OFFk/+CIOjMWiUSNmkh5DT5PwKEXDj60requCFoNR5GsG4vi6Bp24kFLC9CuJ10K+Wgq294faKMntMzPtZM9geD2KUuwTAXoPT/wJT258=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 35/63] ide-cd: coding style fixes for VERBOSE_IDE_CD_ERRORS code
Date: Thu, 20 Dec 2007 02:20:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200220.00690.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Coding style fixes for VERBOSE_IDE_CD_ERRORS code.

* Add KERN_{ERR,CONT} printk() levels where needed.

This is a preparation for moving this code out of ide-cd.[c,h].

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   65 +++++++++++++++++++++++++--------------------------
 drivers/ide/ide-cd.h |   33 ++++++++++++-------------
 2 files changed, 49 insertions(+), 49 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -205,28 +205,30 @@ void cdrom_analyze_sense_data(ide_drive_
 		const char *s = "bad sense key!";
 		char buf[80];
 
-		printk ("ATAPI device %s:\n", drive->name);
-		if (sense->error_code==0x70)
-			printk("  Error: ");
-		else if (sense->error_code==0x71)
+		printk(KERN_ERR "ATAPI device %s:\n", drive->name);
+		if (sense->error_code == 0x70)
+			printk(KERN_CONT "  Error: ");
+		else if (sense->error_code == 0x71)
 			printk("  Deferred Error: ");
 		else if (sense->error_code == 0x7f)
-			printk("  Vendor-specific Error: ");
+			printk(KERN_CONT "  Vendor-specific Error: ");
 		else
-			printk("  Unknown Error Type: ");
+			printk(KERN_CONT "  Unknown Error Type: ");
 
 		if (sense->sense_key < ARRAY_SIZE(sense_key_texts))
 			s = sense_key_texts[sense->sense_key];
 
-		printk("%s -- (Sense key=0x%02x)\n", s, sense->sense_key);
+		printk(KERN_CONT "%s -- (Sense key=0x%02x)\n",
+				 s, sense->sense_key);
 
 		if (sense->asc == 0x40) {
 			sprintf(buf, "Diagnostic failure on component 0x%02x",
-				 sense->ascq);
+				sense->ascq);
 			s = buf;
 		} else {
 			int lo = 0, mid, hi = ARRAY_SIZE(sense_data_texts);
 			unsigned long key = (sense->sense_key << 16);
+
 			key |= (sense->asc << 8);
 			if (!(sense->ascq >= 0x80 && sense->ascq <= 0xdd))
 				key |= sense->ascq;
@@ -238,11 +240,10 @@ void cdrom_analyze_sense_data(ide_drive_
 				    sense_data_texts[mid].asc_ascq == (0xff0000|key)) {
 					s = sense_data_texts[mid].text;
 					break;
-				}
-				else if (sense_data_texts[mid].asc_ascq > key)
+				} else if (sense_data_texts[mid].asc_ascq > key)
 					hi = mid;
 				else
-					lo = mid+1;
+					lo = mid + 1;
 			}
 		}
 
@@ -254,11 +255,10 @@ void cdrom_analyze_sense_data(ide_drive_
 		}
 
 		printk(KERN_ERR "  %s -- (asc=0x%02x, ascq=0x%02x)\n",
-			s, sense->asc, sense->ascq);
+				s, sense->asc, sense->ascq);
 
 		if (failed_command != NULL) {
-
-			int lo=0, mid, hi= ARRAY_SIZE(packet_command_texts);
+			int lo = 0, mid, hi = ARRAY_SIZE(packet_command_texts);
 			s = NULL;
 
 			while (hi > lo) {
@@ -272,13 +272,15 @@ void cdrom_analyze_sense_data(ide_drive_
 				    failed_command->cmd[0])
 					hi = mid;
 				else
-					lo = mid+1;
+					lo = mid + 1;
 			}
 
-			printk (KERN_ERR "  The failed \"%s\" packet command was: \n  \"", s);
-			for (i=0; i<sizeof (failed_command->cmd); i++)
-				printk ("%02x ", failed_command->cmd[i]);
-			printk ("\"\n");
+			printk(KERN_ERR "  The failed \"%s\" packet command "
+					"was: \n  \"", s);
+			for (i = 0; i < sizeof(failed_command->cmd); i++)
+				printk(KERN_CONT "%02x ",
+						 failed_command->cmd[i]);
+			printk(KERN_CONT "\"\n");
 		}
 
 		/* The SKSV bit specifies validity of the sense_key_specific
@@ -288,38 +290,37 @@ void cdrom_analyze_sense_data(ide_drive_
 		 */
 		if (sense->sense_key == NOT_READY && (sense->sks[0] & 0x80)) {
 			int progress = (sense->sks[1] << 8 | sense->sks[2]) * 100;
-			printk(KERN_ERR "  Command is %02d%% complete\n", progress / 0xffff);
 
+			printk(KERN_ERR "  Command is %02d%% complete\n",
+					progress / 0xffff);
 		}
 
 		if (sense->sense_key == ILLEGAL_REQUEST &&
 		    (sense->sks[0] & 0x80) != 0) {
 			printk(KERN_ERR "  Error in %s byte %d",
-				(sense->sks[0] & 0x40) != 0 ?
-				"command packet" : "command data",
-				(sense->sks[1] << 8) + sense->sks[2]);
+					(sense->sks[0] & 0x40) != 0 ?
+					"command packet" : "command data",
+					(sense->sks[1] << 8) + sense->sks[2]);
 
 			if ((sense->sks[0] & 0x40) != 0)
-				printk (" bit %d", sense->sks[0] & 0x07);
+				printk(KERN_CONT " bit %d",
+						 sense->sks[0] & 0x07);
 
-			printk ("\n");
+			printk(KERN_CONT "\n");
 		}
 	}
-
 #else /* not VERBOSE_IDE_CD_ERRORS */
-
 	/* Suppress printing unit attention and `in progress of becoming ready'
 	   errors when we're not being verbose. */
-
 	if (sense->sense_key == UNIT_ATTENTION ||
 	    (sense->sense_key == NOT_READY && (sense->asc == 4 ||
 						sense->asc == 0x3a)))
 		return;
 
-	printk(KERN_ERR "%s: error code: 0x%02x  sense_key: 0x%02x  asc: 0x%02x  ascq: 0x%02x\n",
-		drive->name,
-		sense->error_code, sense->sense_key,
-		sense->asc, sense->ascq);
+	printk(KERN_ERR "%s: error code: 0x%02x  sense_key: 0x%02x  "
+			"asc: 0x%02x  ascq: 0x%02x\n",
+			drive->name, sense->error_code, sense->sense_key,
+			sense->asc, sense->ascq);
 #endif /* not VERBOSE_IDE_CD_ERRORS */
 }
 
Index: b/drivers/ide/ide-cd.h
===================================================================
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -159,9 +159,8 @@ struct cdrom_info {
 
 /* This stuff should be in cdrom.h, since it is now generic... */
 #if VERBOSE_IDE_CD_ERRORS
-
- /* The generic packet command opcodes for CD/DVD Logical Units,
- * From Table 57 of the SFF8090 Ver. 3 (Mt. Fuji) draft standard. */ 
+/* The generic packet command opcodes for CD/DVD Logical Units,
+ * From Table 57 of the SFF8090 Ver. 3 (Mt. Fuji) draft standard. */
 static const struct {
 	unsigned short packet_command;
 	const char * const text;
@@ -187,7 +186,8 @@ static const struct {
 	{ GPCMD_GET_CONFIGURATION, "Get Configuration" },
 	{ GPCMD_PLAY_AUDIO_MSF, "Play Audio MSF" },
 	{ GPCMD_PLAYAUDIO_TI, "Play Audio TrackIndex" },
-	{ GPCMD_GET_EVENT_STATUS_NOTIFICATION, "Get Event Status Notification" },
+	{ GPCMD_GET_EVENT_STATUS_NOTIFICATION,
+		"Get Event Status Notification" },
 	{ GPCMD_PAUSE_RESUME, "Pause/Resume" },
 	{ GPCMD_STOP_PLAY_SCAN, "Stop Play/Scan" },
 	{ GPCMD_READ_DISC_INFO, "Read Disc Info" },
@@ -217,8 +217,6 @@ static const struct {
 	{ GPCMD_READ_CD, "Read CD" },
 };
 
-
-
 /* From Table 303 of the SFF8090 Ver. 3 (Mt. Fuji) draft standard. */
 static const char * const sense_key_texts[16] = {
 	"No sense data",
@@ -262,16 +260,16 @@ static const struct {
 	{ 0x011802, "Recovered data - the data was auto-reallocated" },
 	{ 0x011803, "Recovered data with CIRC" },
 	{ 0x011804, "Recovered data with L-EC" },
-	{ 0x015d00, 
-	    "Failure prediction threshold exceeded - Predicted logical unit failure" },
-	{ 0x015d01, 
-	    "Failure prediction threshold exceeded - Predicted media failure" },
+	{ 0x015d00, "Failure prediction threshold exceeded"
+		    " - Predicted logical unit failure" },
+	{ 0x015d01, "Failure prediction threshold exceeded"
+		    " - Predicted media failure" },
 	{ 0x015dff, "Failure prediction threshold exceeded - False" },
 	{ 0x017301, "Power calibration area almost full" },
 	{ 0x020400, "Logical unit not ready - cause not reportable" },
 	/* Following is misspelled in ATAPI 2.6, _and_ in Mt. Fuji */
-	{ 0x020401,
-	  "Logical unit not ready - in progress [sic] of becoming ready" },
+	{ 0x020401, "Logical unit not ready"
+		    " - in progress [sic] of becoming ready" },
 	{ 0x020402, "Logical unit not ready - initializing command required" },
 	{ 0x020403, "Logical unit not ready - manual intervention required" },
 	{ 0x020404, "Logical unit not ready - format in progress" },
@@ -310,7 +308,6 @@ static const struct {
 	{ 0x037304, "Program memory area / RMA update failure" },
 	{ 0x037305, "Program memory area / RMA is full" },
 	{ 0x037306, "Program memory area / RMA is (almost) full" },
-
 	{ 0x040200, "No seek complete" },
 	{ 0x040300, "Write fault" },
 	{ 0x040900, "Track following error" },
@@ -344,12 +341,15 @@ static const struct {
 	{ 0x055500, "System resource failure" },
 	{ 0x056300, "End of user area encountered on this track" },
 	{ 0x056400, "Illegal mode for this track or incompatible medium" },
-	{ 0x056f00, "Copy protection key exchange failure - Authentication failure" },
+	{ 0x056f00, "Copy protection key exchange failure"
+		    " - Authentication failure" },
 	{ 0x056f01, "Copy protection key exchange failure - Key not present" },
-	{ 0x056f02, "Copy protection key exchange failure - Key not established" },
+	{ 0x056f02, "Copy protection key exchange failure"
+		     " - Key not established" },
 	{ 0x056f03, "Read of scrambled sector without authentication" },
 	{ 0x056f04, "Media region code is mismatched to logical unit" },
-	{ 0x056f05,  "Drive region must be permanent / region reset count error" },
+	{ 0x056f05, "Drive region must be permanent"
+		    " / region reset count error" },
 	{ 0x057203, "Session fixation error - incomplete track in session" },
 	{ 0x057204, "Empty or partially written reserved track" },
 	{ 0x057205, "No more RZONE reservations are allowed" },
@@ -364,7 +364,6 @@ static const struct {
 	{ 0x065a00, "Operator request or state change input (unspecified)" },
 	{ 0x065a01, "Operator medium removal request" },
 	{ 0x0bb900, "Play operation aborted" },
-
 	/* Here we use 0xff for the key (not a valid key) to signify
 	 * that these can have _any_ key value associated with them... */
 	{ 0xff0401, "Logical unit is in process of becoming ready" },
