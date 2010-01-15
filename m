Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0AOBju (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 20:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774Ab0AOBjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 20:39:49 -0500
Received: from [206.15.93.42] ([206.15.93.42]:15476 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750743Ab0AOBjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 20:39:48 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi_sysfs.c: make local symbols static
Date: Thu, 14 Jan 2010 18:39:52 -0700
Cc: James.Bottomley@suse.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141839.52462.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scsi_sysfs.c: make local symbols static

The symbols dev_attr_hstate and scsi_shost_attr_group
are only used locally in this file. Make them static to prevent
the following sparse warnings:

warning: symbol 'dev_attr_hstate' was not declared. Should it be static?
warning: symbol 'scsi_shost_attr_group' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5a06505..5016ab6 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -195,7 +195,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -271,7 +271,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
