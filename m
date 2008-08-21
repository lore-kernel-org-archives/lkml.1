Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYHUFpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYHUFpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYHUFoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:44:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:24080 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYHUFon (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:44:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=hpyvqA3Aij67c9TgWXG+VZApYJLT9VL6HMZFaysJMar6w/pin9kvyyIXr+EAVVIgYN
         z1+WWJiudatK8HfDLQphpUwKtx7pApZg2sIYn/Q91TOfwsT7COTdBMIVdDLudaDbDR9e
         Ff0Mn4ZLRXeIDvKaMKXHYqbvYePsyP0m4H8nQ=
Message-ID: <48AD00D5.5010904@gmail.com>
Date: Wed, 20 Aug 2008 22:44:53 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 01/10] AXFS: exporting xip_file_fault() for use with AXFS
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'll need this for AXFS.  The equivalent function in filemap.c is exported.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
---
 include/linux/mm.h |    4 ++++
 mm/filemap_xip.c   |    3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 72a15dc..2be5c22 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -161,6 +161,10 @@ struct vm_fault {
 					 */
 };
 
+#ifdef CONFIG_FS_XIP
+extern int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
+#endif
+
 /*
  * These are the virtual MM functions - opening of an area, closing and
  * unmapping it (needed to keep files on disk up-to-date etc), pointer
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 380ab40..ab2f174 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -206,7 +206,7 @@ __xip_unmap (struct address_space * mapping,
  *
  * This function is derived from filemap_fault, but used for execute in place
  */
-static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
@@ -262,6 +262,7 @@ found:
 		return 0;
 	}
 }
+EXPORT_SYMBOL_GPL(xip_file_fault);
 
 static struct vm_operations_struct xip_file_vm_ops = {
 	.fault	= xip_file_fault,

