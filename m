Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYEKQnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYEKQnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 12:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYEKQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 12:43:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:59527 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbYEKQnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 12:43:14 -0400
Date: Sun, 11 May 2008 12:43:12 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata no-works fix (RESEND)
Message-ID: <20080511164312.GA1924@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resent from yesterday. Please apply, a ton of people are broken because of this.


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 include/linux/libata.h |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

Jeff Garzik (1):
      [libata] revert new check-ready Status register logic

diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7e206da..0f17643 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1384,17 +1384,14 @@ static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *host)
 
 static inline int ata_check_ready(u8 status)
 {
-	/* Some controllers report 0x77 or 0x7f during intermediate
-	 * not-ready stages.
-	 */
-	if (status == 0x77 || status == 0x7f)
-		return 0;
+	if (!(status & ATA_BUSY))
+		return 1;
 
 	/* 0xff indicates either no device or device not ready */
 	if (status == 0xff)
 		return -ENODEV;
 
-	return !(status & ATA_BUSY);
+	return 0;
 }
 
 
