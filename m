Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbXEUUOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbXEUUOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbXEUUNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:13:45 -0400
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:33973 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934619AbXEUUNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:13:43 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Mon, 21 May 2007 21:13:37 +0100 (BST)
From: Anton Altaparmakov <aia21@cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Teachworth <cteachworth@gmail.com>,
       Richard Russon <ldm@flatcap.org>, linux-kernel@vger.kernel.org,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Fix to the fix! - Re: [2.6 PATCH] LDM: Fix for Windows Vista dynamic
 disks
In-Reply-To: <Pine.LNX.4.64.0705210931310.20659@hermes-1.csi.cam.ac.uk>
Message-ID: <Pine.LNX.4.64.0705212104210.3796@hermes-1.csi.cam.ac.uk>
References: <Pine.LNX.4.64.0705210931310.20659@hermes-1.csi.cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I am a muppet it would seem.  The patch on disk and the one in the email I 
sent have a one line difference which breaks compilation as I just found 
out when I pulled your tree and git showed up the mismatch...  I can only 
assume that that was caused by finger trouble when I inserted the patch 
into the email with pine and then scanned through it quickly paging up and 
down in pine to make sure it was the right patch.  )-:  Alternatively pine 
has started inserting random changes to my emails...  That's rather 
unlikely I know/hope!

Anyway below is the correction to the broken one line...

Hopefully I will manage to send it without breaking it, too!  /-;

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

---
Fix the finger trouble that caused the previous LDM patch to break 
compilation...

CC: Richard Russon <ldm@flatcap.org>
Signed-off-by: Anton Altaparmakov <aia21@cantab.net>
---

diff --git a/fs/partitions/ldm.c b/fs/partitions/ldm.c
index c387812..99873a2 100644
--- a/fs/partitions/ldm.c
+++ b/fs/partitions/ldm.c
@@ -158,7 +158,7 @@ static bool ldm_parse_privhead(const u8 *data, struct privhead *ph)
 		/* Warn the user and continue, carefully. */
 		ldm_info("Database is normally %u bytes, it claims to "
 			"be %llu bytes.", LDM_DB_SIZE,
-			udunsigned long long)ph->config_size);
+			(unsigned long long)ph->config_size);
 	}
 	if ((ph->logical_disk_size == 0) || (ph->logical_disk_start +
 			ph->logical_disk_size > ph->config_start)) {
