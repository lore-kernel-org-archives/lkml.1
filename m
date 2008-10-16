Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbYJPVvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbYJPVvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 17:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYJPVvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 17:51:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41211 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYJPVvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 17:51:36 -0400
Date: Thu, 16 Oct 2008 15:51:35 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Rearrange struct device for better packing
Message-ID: <20081016215135.GS15064@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This minor rearrangement saves 16 bytes from sizeof(struct device)
according to pahole.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/include/linux/device.h b/include/linux/device.h
index 4d8372d..d0624b5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -358,9 +358,9 @@ struct device {
 
 	struct kobject kobj;
 	char	bus_id[BUS_ID_SIZE];	/* position on parent bus */
+	unsigned		uevent_suppress:1;
 	const char		*init_name; /* initial name of the device */
 	struct device_type	*type;
-	unsigned		uevent_suppress:1;
 
 	struct semaphore	sem;	/* semaphore to synchronize calls to
 					 * its driver.
@@ -393,12 +393,13 @@ struct device {
 	/* arch specific additions */
 	struct dev_archdata	archdata;
 
+	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
+
 	spinlock_t		devres_lock;
 	struct list_head	devres_head;
 
 	struct list_head	node;
 	struct class		*class;
-	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	struct attribute_group	**groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
