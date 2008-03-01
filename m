Return-Path: <linux-kernel-owner+w=401wt.eu-S1762178AbYCAJBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762178AbYCAJBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbYCAI7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:1512 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYCAI7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=F0okIMzDdzqXlPtBde3nKM383F8pbaRVhWGJhwbLL/Gf3TVuNcIwpGyUmXqsgKBbs3b7MVImeFakxg7AkJJ9IWx8rYOtyPYFsl8LAzR6vtLVyIMtGy6wH96LFBsi2w3WHDt2lyd1ZyrePv5rbH51oKvM+MPHot5wkgJTEOYfL2g=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 22/24] ide-tape: remove misc references to pipelined operation in the comments
Date: Sat,  1 Mar 2008 09:58:46 +0100
Message-Id: <1204361928-30229-23-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 9810253..07e08a3 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -267,9 +267,7 @@ typedef struct ide_tape_obj {
 	 * While polling for DSC we use postponed_rq to postpone the current
 	 * request so that ide.c will be able to service pending requests on the
 	 * other device. Note that at most we will have only one DSC (usually
-	 * data transfer) request in the device request queue. Additional
-	 * requests can be queued in our internal pipeline, but they will be
-	 * visible to ide.c only one at a time.
+	 * data transfer) request in the device request queue.
 	 */
 	struct request *postponed_rq;
 	/* The time in which we started polling for DSC */
@@ -309,10 +307,8 @@ typedef struct ide_tape_obj {
 	 * At most, there is only one ide-tape originated data transfer request
 	 * in the device request queue. This allows ide.c to easily service
 	 * requests from the other device when we postpone our active request.
-	 * In the pipelined operation mode, we use our internal pipeline
-	 * structure to hold more data requests. The data buffer size is chosen
-	 * based on the tape's recommendation.
 	 */
+
 	/* ptr to the request which is waiting in the device request queue */
 	struct request *active_data_rq;
 	/* Data buffer size chosen based on the tape's recommendation */
@@ -1792,8 +1788,7 @@ static int idetape_init_read(ide_drive_t *drive)
 }
 
 /*
- * Called from idetape_chrdev_read() to service a character device read request
- * and add read-ahead requests to our pipeline.
+ * Called from idetape_chrdev_read() to service a character device read request.
  */
 static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
 {
@@ -2112,8 +2107,7 @@ static int idetape_write_filemark(ide_drive_t *drive)
  *
  * Note: MTBSF and MTBSFM are not supported when the tape doesn't support
  * spacing over filemarks in the reverse direction. In this case, MTFSFM is also
- * usually not supported (it is supported in the rare case in which we crossed
- * the filemark during our read-ahead pipelined operation mode).
+ * usually not supported.
  *
  * The following commands are currently not supported:
  *
@@ -2129,7 +2123,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
 	debug_log(DBG_ERR, "Handling MTIOCTOP ioctl: mt_op=%d, mt_count=%d\n",
 			mt_op, mt_count);
 
-	/* Commands which need our pipelined read-ahead stages. */
 	switch (mt_op) {
 	case MTFSF:
 	case MTFSFM:
-- 
1.5.4.1

