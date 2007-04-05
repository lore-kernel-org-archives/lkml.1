Return-Path: <linux-kernel-owner+w=401wt.eu-S1767014AbXDEOnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767014AbXDEOnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767018AbXDEOnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:43:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:37920 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767009AbXDEOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:43:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=YMkM5xObHRLRq7kmcI5sfm74q8kPqt+qGP4qDMBF3OUDHW12+OCS2C4VFx0c1bhqDiLludcYP0V/ZiCLFFT9GBoJp1fRNkJ8uNuywfTiPl2PxBCEdS05gt53yoJg2nLzNy8HLnh9pGFShtH+Yk+hRtej6BtEZBPHCOclqAxXvhQ=
Date: Thu, 5 Apr 2007 20:14:20 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [KJ][PATCH]ROUND_UP macro cleanup in fs/smbfs/request.c
Message-ID: <20070405144420.GA10696@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ROUND_UP macro cleanup use ALIGN

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---

 request.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/fs/smbfs/request.c b/fs/smbfs/request.c
index 723f7c6..c288fbe 100644
--- a/fs/smbfs/request.c
+++ b/fs/smbfs/request.c
@@ -6,6 +6,7 @@
  *  Please add a note about your changes to smbfs in the ChangeLog file.
  */
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
@@ -22,8 +23,6 @@
 /* #define SMB_SLAB_DEBUG	(SLAB_RED_ZONE | SLAB_POISON) */
 #define SMB_SLAB_DEBUG	0
 
-#define ROUND_UP(x) (((x)+3) & ~3)
-
 /* cache for request structures */
 static struct kmem_cache *req_cachep;
 
@@ -200,8 +199,8 @@ static int smb_setup_trans2request(struct smb_request *req)
 
 	const int smb_parameters = 15;
 	const int header = SMB_HEADER_LEN + 2 * smb_parameters + 2;
-	const int oparam = ROUND_UP(header + 3);
-	const int odata  = ROUND_UP(oparam + req->rq_lparm);
+	const int oparam = ALIGN(header + 3, sizeof(u32));
+	const int odata  = ALIGN(oparam + req->rq_lparm, sizeof(u32));
 	const int bcc = (req->rq_data ? odata + req->rq_ldata :
 					oparam + req->rq_lparm) - header;
 

-- 
Milind Arun Choudhary
