Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbXIBUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbXIBUKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXIBUKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:10:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56893 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbXIBUKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:10:04 -0400
Date: Mon, 3 Sep 2007 01:53:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: James Bottomley <james.bottomley@steeleye.com>,
       Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org
Subject: [PATCH -mm] DC395x SCSI driver: Shut up uninitialized variable build
 warning
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-1256607607-1188764595=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-1256607607-1188764595=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


drivers/scsi/dc395x.c: In function ‘dc395x_init_one’:
drivers/scsi/dc395x.c:4272: warning: ‘ptr’ may be used uninitialized in this function

has been verified to be a bogus warning. Let's shut it up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/scsi/dc395x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c~fix	2007-09-02 20:57:51.000000000 +0530
+++ linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c	2007-09-02 21:10:49.000000000 +0530
@@ -4269,7 +4269,7 @@ static int __devinit adapter_sg_tables_a
 	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
 	int srb_idx = 0;
 	unsigned i = 0;
-	struct SGentry *ptr;
+	struct SGentry * uninitialized_var(ptr);
 
 	for (i = 0; i < DC395x_MAX_SRB_CNT; i++)
 		acb->srb_array[i].segment_x = NULL;
--464262402-1256607607-1188764595=:29617--
