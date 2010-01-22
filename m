Return-Path: <linux-kernel-owner+w=401wt.eu-S932198Ab0AVE5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab0AVE5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002Ab0AVE4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:36 -0500
Received: from mail.perches.com ([173.55.12.10]:1346 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0AVEw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:52:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 08/24] drivers/block/floppy.c: Comment neatening and remove naked ;
Date: Thu, 21 Jan 2010 20:52:38 -0800
Message-Id: <14ce85f7b5adf5b40e982a5a870c5dd00a2071cb.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spacing, column alignment and a for loop with
a naked semicolon converted to an assign and while

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   55 ++++++++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9f7a658..f274aff 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1262,9 +1262,12 @@ static inline void perpendicular_mode(void)
 		default:
 			DPRINT("Invalid data rate for perpendicular mode!\n");
 			cont->done(0);
-			FDCS->reset = 1;	/* convenient way to return to
-						 * redo without to much hassle (deep
-						 * stack et al. */
+			FDCS->reset = 1;
+					/*
+					 * convenient way to return to
+					 * redo without too much hassle
+					 * (deep stack et al.)
+					 */
 			return;
 		}
 	} else
@@ -1977,8 +1980,8 @@ static void floppy_ready(void)
 #endif
 	if (!(raw_cmd->flags & FD_RAW_NO_MOTOR) &&
 	    disk_change(current_drive) && !DP->select_delay)
-		twaddle();	/* this clears the dcl on certain drive/controller
-				 * combinations */
+		twaddle();	/* this clears the dcl on certain
+				 * drive/controller combinations */
 
 #ifdef fd_chose_dma_mode
 	if ((raw_cmd->flags & FD_RAW_READ) || (raw_cmd->flags & FD_RAW_WRITE)) {
@@ -2806,15 +2809,14 @@ static int make_raw_rw_request(void)
 	    ((CT(COMMAND) == FD_READ ||
 	      (!in_sector_offset && blk_rq_sectors(current_req) >= ssize)) &&
 	     max_sector > 2 * max_buffer_sectors + buffer_min &&
-	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)
-	    /* not enough space */
-	    ) {
+	     max_size + fsector_t > 2 * max_buffer_sectors + buffer_min)) {
+		/* not enough space */
 		buffer_track = -1;
 		buffer_drive = current_drive;
 		buffer_max = buffer_min = aligned_sector_t;
 	}
 	raw_cmd->kernel_data = floppy_track_buffer +
-	    ((aligned_sector_t - buffer_min) << 9);
+		((aligned_sector_t - buffer_min) << 9);
 
 	if (CT(COMMAND) == FD_WRITE) {
 		/* copy write buffer to track buffer.
@@ -3171,11 +3173,12 @@ static inline int raw_cmd_copyout(int cmd, char __user *param,
 		COPYOUT(*ptr);
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
-			if (ptr->length >= 0
-			    && ptr->length <= ptr->buffer_length)
-				ECALL(fd_copyout
-				      (ptr->data, ptr->kernel_data,
-				       ptr->buffer_length - ptr->length));
+			if (ptr->length >= 0 &&
+			    ptr->length <= ptr->buffer_length) {
+				long length = ptr->buffer_length - ptr->length;
+				ECALL(fd_copyout(ptr->data, ptr->kernel_data,
+						 length));
+			}
 		}
 		ptr = ptr->next;
 	}
@@ -3827,8 +3830,7 @@ static int check_floppy_change(struct gendisk *disk)
  * a disk in the drive, and whether that disk is writable.
  */
 
-static void floppy_rb0_complete(struct bio *bio,
-			       int err)
+static void floppy_rb0_complete(struct bio *bio, int err)
 {
 	complete((struct completion *)bio->bi_private);
 }
@@ -4120,9 +4122,9 @@ static int __init floppy_setup(char *str)
 				else
 					param = config_params[i].def_param;
 				if (config_params[i].fn)
-					config_params[i].
-					    fn(ints, param,
-					       config_params[i].param2);
+					config_params[i].fn(ints, param,
+							    config_params[i].
+							    param2);
 				if (config_params[i].var) {
 					DPRINT("%s=%d\n", str, param);
 					*config_params[i].var = param;
@@ -4180,8 +4182,8 @@ static const struct dev_pm_ops floppy_pm_ops = {
 
 static struct platform_driver floppy_driver = {
 	.driver = {
-		.name = "floppy",
-		.pm = &floppy_pm_ops,
+		   .name = "floppy",
+		   .pm = &floppy_pm_ops,
 	},
 };
 
@@ -4429,8 +4431,10 @@ static int floppy_request_regions(int fdc)
 	const struct io_region *p;
 
 	for (p = io_regions; p < ARRAY_END(io_regions); p++) {
-		if (!request_region(FDCS->address + p->offset, p->size, "floppy")) {
-			DPRINT("Floppy io-port 0x%04lx in use\n", FDCS->address + p->offset);
+		if (!request_region(FDCS->address + p->offset,
+				    p->size, "floppy")) {
+			DPRINT("Floppy io-port 0x%04lx in use\n",
+			       FDCS->address + p->offset);
 			floppy_release_allocated_regions(fdc, p);
 			return -EBUSY;
 		}
@@ -4586,8 +4590,9 @@ static void __init parse_floppy_cfg_string(char *cfg)
 	char *ptr;
 
 	while (*cfg) {
-		for (ptr = cfg; *cfg && *cfg != ' ' && *cfg != '\t'; cfg++)
-			;
+		ptr = cfg;
+		while (*cfg && *cfg != ' ' && *cfg != '\t')
+			cfg++;
 		if (*cfg) {
 			*cfg = '\0';
 			cfg++;
-- 
1.6.6.rc0.57.gad7a

