Return-Path: <linux-kernel-owner+w=401wt.eu-S932927AbXBFQGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932927AbXBFQGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932922AbXBFQGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:06:14 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:58148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXBFQFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:05:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=sD4IwDEQoVTbYZbjN32sj6JraOuChOmDpzOdcZy6vK4qWXyKGET1KRaHuH22svyoAohsWUdDmiXnUFvdMeFNNzfPrRQVkkyLej3G5eEnOnKR0bP6rcm/37Uq7LfPVr/rT1l2QQHXFosQO3gqrUb5LE2K1wcmSJ5fCMgouNrRF1k=
Date: Tue, 6 Feb 2007 18:05:39 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 2/2] OSS: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160539.GG8991@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206160204.GA8991@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
I couldn't compile-test this patch with `allyesconfig' or `allmodconfig'.

 au1550_ac97.c   |    4 ++--
 nec_vrc5477.c   |    4 ++--
 swarm_cs4297a.c |    3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index 2197951..a339f0c 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -1354,11 +1354,11 @@ au1550_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 		((file->f_mode & FMODE_READ) && s->dma_adc.mapped);
 
 #ifdef DEBUG
-	for (count=0; count<sizeof(ioctl_str)/sizeof(ioctl_str[0]); count++) {
+	for (count = 0; count < ARRAY_SIZE(ioctl_str); count++) {
 		if (ioctl_str[count].cmd == cmd)
 			break;
 	}
-	if (count < sizeof(ioctl_str) / sizeof(ioctl_str[0]))
+	if (count < ARRAY_SIZE(ioctl_str))
 		pr_debug("ioctl %s, arg=0x%lxn", ioctl_str[count].str, arg);
 	else
 		pr_debug("ioctl 0x%x unknown, arg=0x%lx\n", cmd, arg);
diff --git a/sound/oss/nec_vrc5477.c b/sound/oss/nec_vrc5477.c
index da9728e..d459bdb 100644
--- a/sound/oss/nec_vrc5477.c
+++ b/sound/oss/nec_vrc5477.c
@@ -1381,11 +1381,11 @@ static int vrc5477_ac97_ioctl(struct inode *inode, struct file *file,
 	int val, ret;
 
 #ifdef VRC5477_AC97_DEBUG
-	for (count=0; count<sizeof(ioctl_str)/sizeof(ioctl_str[0]); count++) {
+	for (count = 0; count < ARRAY_SIZE(ioctl_str); count++) {
 		if (ioctl_str[count].cmd == cmd)
 			break;
 	}
-	if (count < sizeof(ioctl_str)/sizeof(ioctl_str[0]))
+	if (count < ARRAY_SIZE(ioctl_str))
 		printk(KERN_INFO PFX "ioctl %s\n", ioctl_str[count].str);
 	else
 		printk(KERN_INFO PFX "ioctl unknown, 0x%x\n", cmd);
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 471c274..9f7e5f5 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -77,6 +77,7 @@
 #include <linux/poll.h>
 #include <linux/smp_lock.h>
 #include <linux/mutex.h>
+#include <linux/kernel.h>
 
 #include <asm/byteorder.h>
 #include <asm/dma.h>
@@ -2676,7 +2677,7 @@ static int __init cs4297a_init(void)
 #if 0
                 val = SOUND_MASK_LINE;
                 mixer_ioctl(s, SOUND_MIXER_WRITE_RECSRC, (unsigned long) &val);
-                for (i = 0; i < sizeof(initvol) / sizeof(initvol[0]); i++) {
+                for (i = 0; i < ARRAY_SIZE(initvol); i++) {
                         val = initvol[i].vol;
                         mixer_ioctl(s, initvol[i].mixch, (unsigned long) &val);
                 }

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
