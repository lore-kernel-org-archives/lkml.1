Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbYBFF1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbYBFF1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 00:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYBFF11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 00:27:27 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:41991 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYBFF10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 00:27:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=jO7/8NDgfyWIWeB9zUjDchXoZEvXZ8gc1q3/9moUwQGiheQ+QodMtEPlajVYM/VqXdspL/+H/9XatSqA2g0jwUKf7baG1B11itdsun65VF2D/21E1oG8Nc0shR93N0Q+kKiUxQrS3By9t0zugGN6EEGTrUldP+OvNP0Bt2fpg8k=
Date: Wed, 6 Feb 2008 06:27:15 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ide-tape redux (was: Re:)
Message-ID: <20080206052715.GB14349@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <200802050220.22637.bzolnier@gmail.com> <20080206052343.GA14349@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080206052343.GA14349@gollum.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and while we're at it ...

commit c824f79fe4040f7541d7e35c546bb57a22d2fe11
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Wed Feb 6 06:23:10 2008 +0100

    ide-tape: move all struct and other defs to the top
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 9455ce4..398aea8 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -225,6 +225,69 @@ enum {
 	PC_FL_WRITING		= (1 <<	5),
 };
 
+/* Tape door status */
+#define DOOR_UNLOCKED			0
+#define DOOR_LOCKED			1
+#define DOOR_EXPLICITLY_LOCKED		2
+
+/* Tape flag bits values. */
+enum {
+	IDETAPE_FL_IGNORE_DSC		= (1 << 0),
+	/* 0 When the tape position is unknown */
+	IDETAPE_FL_ADDRESS_VALID	= (1 <<	1),
+	/* Device already opened */
+	IDETAPE_FL_BUSY			= (1 << 2),
+	/* Error detected in a pipeline stage */
+	IDETAPE_FL_PIPELINE_ERR	= (1 <<	3),
+	/* Attempt to auto-detect the current user block size */
+	IDETAPE_FL_DETECT_BS		= (1 << 4),
+	/* Currently on a filemark */
+	IDETAPE_FL_FILEMARK		= (1 << 5),
+	/* DRQ interrupt device */
+	IDETAPE_FL_DRQ_INTERRUPT	= (1 << 6),
+	/* pipeline active */
+	IDETAPE_FL_PIPELINE_ACTIVE	= (1 << 7),
+	/* 0 = no tape is loaded, so we don't rewind after ejecting */
+	IDETAPE_FL_MEDIUM_PRESENT	= (1 << 8),
+};
+
+/* A define for the READ BUFFER command */
+#define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
+
+/* Some defines for the SPACE command */
+#define IDETAPE_SPACE_OVER_FILEMARK	1
+#define IDETAPE_SPACE_TO_EOD		3
+
+/* Some defines for the LOAD UNLOAD command */
+#define IDETAPE_LU_LOAD_MASK		1
+#define IDETAPE_LU_RETENSION_MASK	2
+#define IDETAPE_LU_EOT_MASK		4
+
+/*
+ * Special requests for our block device strategy routine.
+ *
+ * In order to service a character device command, we add special requests to
+ * the tail of our block device request queue and wait for their completion.
+ */
+
+enum {
+	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
+	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
+	REQ_IDETAPE_READ	= (1 << 2),
+	REQ_IDETAPE_WRITE	= (1 << 3),
+	REQ_IDETAPE_READ_BUFFER	= (1 << 4),
+};
+
+/* Error codes returned in rq->errors to the higher part of the driver. */
+#define	IDETAPE_ERROR_GENERAL		101
+#define	IDETAPE_ERROR_FILEMARK		102
+#define	IDETAPE_ERROR_EOD		103
+
+/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
+#define IDETAPE_BLOCK_DESCRIPTOR	0
+#define	IDETAPE_CAPABILITIES_PAGE	0x2a
+
+
 /* A pipeline stage. */
 typedef struct idetape_stage_s {
 	struct request rq;			/* The corresponding request */
@@ -445,68 +508,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	mutex_unlock(&idetape_ref_mutex);
 }
 
-/* Tape door status */
-#define DOOR_UNLOCKED			0
-#define DOOR_LOCKED			1
-#define DOOR_EXPLICITLY_LOCKED		2
-
-/* Tape flag bits values. */
-enum {
-	IDETAPE_FL_IGNORE_DSC		= (1 << 0),
-	/* 0 When the tape position is unknown */
-	IDETAPE_FL_ADDRESS_VALID	= (1 <<	1),
-	/* Device already opened */
-	IDETAPE_FL_BUSY			= (1 << 2),
-	/* Error detected in a pipeline stage */
-	IDETAPE_FL_PIPELINE_ERR	= (1 <<	3),
-	/* Attempt to auto-detect the current user block size */
-	IDETAPE_FL_DETECT_BS		= (1 << 4),
-	/* Currently on a filemark */
-	IDETAPE_FL_FILEMARK		= (1 << 5),
-	/* DRQ interrupt device */
-	IDETAPE_FL_DRQ_INTERRUPT	= (1 << 6),
-	/* pipeline active */
-	IDETAPE_FL_PIPELINE_ACTIVE	= (1 << 7),
-	/* 0 = no tape is loaded, so we don't rewind after ejecting */
-	IDETAPE_FL_MEDIUM_PRESENT	= (1 << 8),
-};
-
-/* A define for the READ BUFFER command */
-#define IDETAPE_RETRIEVE_FAULTY_BLOCK	6
-
-/* Some defines for the SPACE command */
-#define IDETAPE_SPACE_OVER_FILEMARK	1
-#define IDETAPE_SPACE_TO_EOD		3
-
-/* Some defines for the LOAD UNLOAD command */
-#define IDETAPE_LU_LOAD_MASK		1
-#define IDETAPE_LU_RETENSION_MASK	2
-#define IDETAPE_LU_EOT_MASK		4
-
-/*
- * Special requests for our block device strategy routine.
- *
- * In order to service a character device command, we add special requests to
- * the tail of our block device request queue and wait for their completion.
- */
-
-enum {
-	REQ_IDETAPE_PC1		= (1 << 0), /* packet command (first stage) */
-	REQ_IDETAPE_PC2		= (1 << 1), /* packet command (second stage) */
-	REQ_IDETAPE_READ	= (1 << 2),
-	REQ_IDETAPE_WRITE	= (1 << 3),
-	REQ_IDETAPE_READ_BUFFER	= (1 << 4),
-};
-
-/* Error codes returned in rq->errors to the higher part of the driver. */
-#define	IDETAPE_ERROR_GENERAL		101
-#define	IDETAPE_ERROR_FILEMARK		102
-#define	IDETAPE_ERROR_EOD		103
-
-/* Structures related to the SELECT SENSE / MODE SENSE packet commands. */
-#define IDETAPE_BLOCK_DESCRIPTOR	0
-#define	IDETAPE_CAPABILITIES_PAGE	0x2a
-
 /*
  * The variables below are used for the character device interface. Additional
  * state variables are defined in our ide_drive_t structure.

-- 
Regards/Gruﬂ,
    Boris.
