Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbXJ0SoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbXJ0SoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbXJ0SoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:44:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33029 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbXJ0SoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:44:08 -0400
Date: Sat, 27 Oct 2007 19:44:04 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: rmk@arm.linux.org.uk, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] scatterlist fallout: drivers/scsi/arm/
Message-ID: <20071027184404.GQ8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/scsi/arm/scsi.h b/drivers/scsi/arm/scsi.h
index 21ba571..2d09fef 100644
--- a/drivers/scsi/arm/scsi.h
+++ b/drivers/scsi/arm/scsi.h
@@ -39,7 +39,7 @@ static inline int next_SCp(struct scsi_pointer *SCp)
 		SCp->buffer++;
 		SCp->buffers_residual--;
 		SCp->ptr = (char *)
-			 (page_address(SCp->buffer->page) +
+			 (page_address(sg_page(SCp->buffer)) +
 			  SCp->buffer->offset);
 		SCp->this_residual = SCp->buffer->length;
 	} else {
@@ -77,7 +77,7 @@ static inline void init_SCp(struct scsi_cmnd *SCpnt)
 		SCpnt->SCp.buffer = (struct scatterlist *) SCpnt->request_buffer;
 		SCpnt->SCp.buffers_residual = SCpnt->use_sg - 1;
 		SCpnt->SCp.ptr = (char *)
-			 (page_address(SCpnt->SCp.buffer->page) +
+			 (page_address(sg_page(SCpnt->SCp.buffer)) +
 			  SCpnt->SCp.buffer->offset);
 		SCpnt->SCp.this_residual = SCpnt->SCp.buffer->length;
 		SCpnt->SCp.phase = SCpnt->request_bufflen;
