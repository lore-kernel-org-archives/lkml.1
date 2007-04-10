Return-Path: <linux-kernel-owner+w=401wt.eu-S1030658AbXDJO1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030658AbXDJO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030656AbXDJO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:27:52 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:7768 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030658AbXDJO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:27:51 -0400
Date: Tue, 10 Apr 2007 16:30:09 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] sysfs: kill unnecessary attribute->owner
Message-ID: <20070410163009.2d7371e9@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070410161706.7764cd11@gondolin.boeblingen.de.ibm.com>
References: <11760923261269-git-send-email-htejun@gmail.com>
	<11760923293601-git-send-email-htejun@gmail.com>
	<20070410161706.7764cd11@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 16:17:06 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> You missed some s390 attributes :)

Oops, wrong tree, sorry.

---
 arch/s390/kernel/ipl.c      |    2 --
 drivers/s390/cio/chsc.c     |    2 --
 drivers/s390/net/qeth_sys.c |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

--- linux.orig/arch/s390/kernel/ipl.c
+++ linux/arch/s390/kernel/ipl.c
@@ -255,7 +255,6 @@ static struct bin_attribute ipl_paramete
 	.attr = {
 		.name = "binary_parameter",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = PAGE_SIZE,
 	.read = &ipl_parameter_read,
@@ -279,7 +278,6 @@ static struct bin_attribute ipl_scp_data
 	.attr = {
 		.name = "scp_data",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = PAGE_SIZE,
 	.read = &ipl_scp_data_read,
--- linux.orig/drivers/s390/net/qeth_sys.c
+++ linux/drivers/s390/net/qeth_sys.c
@@ -993,7 +993,7 @@ static struct attribute_group qeth_osn_d
 
 #define QETH_DEVICE_ATTR(_id,_name,_mode,_show,_store)			     \
 struct device_attribute dev_attr_##_id = {				     \
-	.attr = {.name=__stringify(_name), .mode=_mode, .owner=THIS_MODULE },\
+	.attr = {.name=__stringify(_name), .mode=_mode, },\
 	.show	= _show,						     \
 	.store	= _store,						     \
 };
--- linux.orig/drivers/s390/cio/chsc.c
+++ linux/drivers/s390/cio/chsc.c
@@ -898,7 +898,6 @@ static struct bin_attribute chp_measurem
 	.attr = {
 		.name = "measurement_chars",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(struct cmg_chars),
 	.read = chp_measurement_chars_read,
@@ -950,7 +949,6 @@ static struct bin_attribute chp_measurem
 	.attr = {
 		.name = "measurement",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(struct cmg_entry),
 	.read = chp_measurement_read,
