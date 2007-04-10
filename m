Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbXDJOOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbXDJOOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbXDJOOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:14:51 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:26096 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030574AbXDJOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:14:50 -0400
Date: Tue, 10 Apr 2007 16:17:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] sysfs: kill unnecessary attribute->owner
Message-ID: <20070410161706.7764cd11@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11760923293601-git-send-email-htejun@gmail.com>
References: <11760923261269-git-send-email-htejun@gmail.com>
	<11760923293601-git-send-email-htejun@gmail.com>
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

On Mon, 9 Apr 2007 13:18:49 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> sysfs is now completely out of driver/module lifetime game.  After
> deletion, a sysfs node doesn't access anything outside sysfs proper,
> so there's no reason to hold onto the attribute owners.  Note that
> often the wrong modules were accounted for as owners leading to
> accessing removed modules.
> 
> This patch kills now unnecessary attribute->owner.  Note that with
> this change, userland holding a sysfs node does not prevent the
> backing module from being unloaded.
> 
> For more info regarding lifetime rule cleanup, please read the
> following message.
> 
>   http://article.gmane.org/gmane.linux.kernel/510293
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

You missed some s390 attributes :)

---
 arch/s390/kernel/ipl.c      |    2 --
 drivers/s390/cio/chp.c      |    2 --
 drivers/s390/net/qeth_sys.c |    2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

--- linux-2.6.orig/arch/s390/kernel/ipl.c
+++ linux-2.6/arch/s390/kernel/ipl.c
@@ -314,7 +314,6 @@ static struct bin_attribute ipl_paramete
 	.attr = {
 		.name = "binary_parameter",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = PAGE_SIZE,
 	.read = &ipl_parameter_read,
@@ -338,7 +337,6 @@ static struct bin_attribute ipl_scp_data
 	.attr = {
 		.name = "scp_data",
 		.mode = S_IRUGO,
-		.owner = THIS_MODULE,
 	},
 	.size = PAGE_SIZE,
 	.read = &ipl_scp_data_read,
--- linux-2.6.orig/drivers/s390/cio/chp.c
+++ linux-2.6/drivers/s390/cio/chp.c
@@ -165,7 +165,6 @@ static struct bin_attribute chp_measurem
 	.attr = {
 		.name = "measurement_chars",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(struct cmg_chars),
 	.read = chp_measurement_chars_read,
@@ -217,7 +216,6 @@ static struct bin_attribute chp_measurem
 	.attr = {
 		.name = "measurement",
 		.mode = S_IRUSR,
-		.owner = THIS_MODULE,
 	},
 	.size = sizeof(struct cmg_entry),
 	.read = chp_measurement_read,
--- linux-2.6.orig/drivers/s390/net/qeth_sys.c
+++ linux-2.6/drivers/s390/net/qeth_sys.c
@@ -993,7 +993,7 @@ static struct attribute_group qeth_osn_d
 
 #define QETH_DEVICE_ATTR(_id,_name,_mode,_show,_store)			     \
 struct device_attribute dev_attr_##_id = {				     \
-	.attr = {.name=__stringify(_name), .mode=_mode, .owner=THIS_MODULE },\
+	.attr = {.name=__stringify(_name), .mode=_mode, },\
 	.show	= _show,						     \
 	.store	= _store,						     \
 };
