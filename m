Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbZLKEmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbZLKEmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762519AbZLKEmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:42:38 -0500
Received: from kroah.org ([198.145.64.141]:37165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762297AbZLKEgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:36:50 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:28:21 2009
Message-Id: <20091211042820.904178854@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:26:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [86/90] SCSI: megaraid_sas: fix 64 bit sense pointer truncation
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=scsi-megaraid_sas-fix-64-bit-sense-pointer-truncation.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Yang, Bo <Bo.Yang@lsi.com>

commit 7b2519afa1abd1b9f63aa1e90879307842422dae upstream.

The current sense pointer is cast to a u32 pointer, which can truncate
on 64 bits.  Fix by using unsigned long instead.

Signed-off-by Bo Yang<bo.yang@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/megaraid/megaraid_sas.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3032,7 +3032,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	int error = 0, i;
 	void *sense = NULL;
 	dma_addr_t sense_handle;
-	u32 *sense_ptr;
+	unsigned long *sense_ptr;
 
 	memset(kbuff_arr, 0, sizeof(kbuff_arr));
 
@@ -3109,7 +3109,7 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 		}
 
 		sense_ptr =
-		    (u32 *) ((unsigned long)cmd->frame + ioc->sense_off);
+		(unsigned long *) ((unsigned long)cmd->frame + ioc->sense_off);
 		*sense_ptr = sense_handle;
 	}
 
@@ -3140,8 +3140,8 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 		 * sense_ptr points to the location that has the user
 		 * sense buffer address
 		 */
-		sense_ptr = (u32 *) ((unsigned long)ioc->frame.raw +
-				     ioc->sense_off);
+		sense_ptr = (unsigned long *) ((unsigned long)ioc->frame.raw +
+				ioc->sense_off);
 
 		if (copy_to_user((void __user *)((unsigned long)(*sense_ptr)),
 				 sense, ioc->sense_len)) {


