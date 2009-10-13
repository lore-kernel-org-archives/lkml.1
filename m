Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbZJMPBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbZJMPBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbZJMPBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:01:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40494 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760159AbZJMPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:01:11 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] sep: Fix use of legacy ioctl fop
To: gregk@kroah.com, linux-kernel@vger.kernel.org, arndbergmann@googlemail.com
Date: Tue, 13 Oct 2009 15:48:58 +0100
Message-ID: <20091013144856.31420.33386.stgit@localhost.localdomain>
In-Reply-To: <20091013144716.31420.47979.stgit@localhost.localdomain>
References: <20091013144716.31420.47979.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SEP doesn't need lock_kernel.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 2ecd62d..23b4db1 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2231,7 +2231,7 @@ static int sep_set_flow_id_handler(struct sep_device *sep,
 	return error;
 }
 
-static int sep_ioctl(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg)
+static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	int error = 0;
 	struct sep_device *sep = filp->private_data;
@@ -2606,7 +2606,7 @@ static dev_t sep_devno;
 /* the files operations structure of the driver */
 static struct file_operations sep_file_operations = {
 	.owner = THIS_MODULE,
-	.ioctl = sep_ioctl,
+	.unlocked_ioctl = sep_ioctl,
 	.poll = sep_poll,
 	.open = sep_open,
 	.release = sep_release,

