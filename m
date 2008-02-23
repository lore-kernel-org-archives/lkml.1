Return-Path: <linux-kernel-owner+w=401wt.eu-S965077AbYBWI3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077AbYBWI3x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936768AbYBWITi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:19:38 -0500
Received: from qb-out-0506.google.com ([72.14.204.234]:40294 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936157AbYBWITg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:19:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QXFfRlMHamPNDlg0teJTtxA1vG4gq/Ku462dGwnhkiSHKN6ZKWRtmOS8ID2vmqGVV0T2ehhfo3aOnEOCwtqO83wnyP2ex/KUqIaNKHNbYvcfzUVsQS+LeV7vbv3bdIkNluU2kkMwpen0hz7TrmDCKcjbdWJap3aQ2Z1eyCC/htA=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 02/16] mm: use get_personality()
Date: Sat, 23 Feb 2008 16:14:05 +0800
Message-Id: <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for mm/ code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Lameter <clameter@sgi.com> 

---
 mm/mmap.c     |    2 +-
 mm/mprotect.c |    2 +-
 mm/nommu.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index a32d28c..42d647f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -910,7 +910,7 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 	 * (the exception is when the underlying filesystem is noexec
 	 *  mounted, in which case we dont add PROT_EXEC.)
 	 */
-	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
+	if ((prot & PROT_READ) && (get_personality() & READ_IMPLIES_EXEC))
 		if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
 			prot |= PROT_EXEC;
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 4de5468..620b8db 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -237,7 +237,7 @@ sys_mprotect(unsigned long start, size_t len, unsigned long prot)
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC:
 	 */
-	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
+	if ((prot & PROT_READ) && (get_personality() & READ_IMPLIES_EXEC))
 		prot |= PROT_EXEC;
 
 	vm_flags = calc_vm_prot_bits(prot);
diff --git a/mm/nommu.c b/mm/nommu.c
index 5d8ae08..a1c6162 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -665,7 +665,7 @@ static int validate_mmap_request(struct file *file,
 		}
 		else if ((prot & PROT_READ) && !(prot & PROT_EXEC)) {
 			/* handle implication of PROT_EXEC by PROT_READ */
-			if (current->personality & READ_IMPLIES_EXEC) {
+			if (get_personality() & READ_IMPLIES_EXEC) {
 				if (capabilities & BDI_CAP_EXEC_MAP)
 					prot |= PROT_EXEC;
 			}
@@ -686,7 +686,7 @@ static int validate_mmap_request(struct file *file,
 
 		/* handle PROT_EXEC implication by PROT_READ */
 		if ((prot & PROT_READ) &&
-		    (current->personality & READ_IMPLIES_EXEC))
+		    (get_personality() & READ_IMPLIES_EXEC))
 			prot |= PROT_EXEC;
 	}
 
-- 
1.5.3.8

