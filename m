Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXJZLT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXJZLT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 07:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXJZLTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 07:19:51 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57903 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbXJZLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 07:19:49 -0400
Date: Fri, 26 Oct 2007 16:49:45 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-s390@vger.kernel.org
Subject: S390 change in sg_set_page() cause build failure
Message-ID: <20071026111945.GB21274@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

The change in the sg_set_page() for the S390, cause the build failure

drivers/s390/scsi/zfcp_aux.c: In function `zfcp_sg_list_alloc':
drivers/s390/scsi/zfcp_aux.c:572: error: too many arguments to function `zfcp_address_to_sg'
drivers/s390/scsi/zfcp_aux.c: In function `zfcp_gid_pn_buffers_alloc':
drivers/s390/scsi/zfcp_aux.c:1524: error: too many arguments to function `zfcp_address_to_sg'
drivers/s390/scsi/zfcp_aux.c:1525: error: too many arguments to function `zfcp_address_to_sg'
make[2]: *** [drivers/s390/scsi/zfcp_aux.o] Error 1
make[1]: *** [drivers/s390/scsi] Error 2
make: *** [drivers/s390] Error 2

The commit 642f149031d70415d9318b919d50b71e4724adbd causes this build
failure, in the drivers/s390/scsi/zfcp_def.h include file, the function
zfcp_address_to_sg the len of the scatterlist missing.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 0754542..acf2d22 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -70,9 +70,11 @@ zfcp_sg_to_address(struct scatterlist *list)
  * zfcp_address_to_sg - set up struct scatterlist from kernel address
  * @address: kernel address
  * @list: struct scatterlist
+ * @list_size: size of the list - used for compatibility 
  */
 static inline void
-zfcp_address_to_sg(void *address, struct scatterlist *list)
+zfcp_address_to_sg(void *address, struct scatterlist *list,
+                   unsigned int list_size)
 {
 	sg_set_buf(list, address, 0);
 }
--
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM,ISTL.
