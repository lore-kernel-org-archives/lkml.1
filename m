Return-Path: <linux-kernel-owner+w=401wt.eu-S1765471AbYETJ6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765471AbYETJ6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765509AbYETJ5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:57:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:55693 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765240AbYETJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:57:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fXx+9boy/bDG54dLcraPjv8iriPpZaxbH44ikpa6CUeY8Vrioh78moHUYpKNgZx0Cl3MlS9WDNCYJM+dMAEvyfLjYmX30fpPs3RPw1BntGqb/k/0EfjOp9WMz7/oZ0HIeFt3u/ij+l7M3R7EcxeGxZWIUvQOboJQsLHNuI+QsFo=
Date: Tue, 20 May 2008 17:58:51 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Message-ID: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Please first apply the patch 1/3 before this]

To please lockdep here we use class_reclassify to change
the lock class of sg_sysfs_class

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
 drivers/scsi/sg.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux/drivers/scsi/sg.c	2008-05-19 12:41:05.000000000 +0800
+++ linux.new/drivers/scsi/sg.c	2008-05-19 14:08:19.000000000 +0800
@@ -1579,6 +1579,8 @@ init_sg(void)
 		rc = PTR_ERR(sg_sysfs_class);
 		goto err_out;
         }
+
+	class_reclassify(sg_sysfs_class);
 	sg_sysfs_valid = 1;
 	rc = scsi_register_interface(&sg_interface);
 	if (0 == rc) {
