Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXBFQFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXBFQFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932927AbXBFQFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:05:48 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:58148 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbXBFQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:05:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=fwihufkzdRTwflSHgTBx4iFFKVKsBK3gFLfQqXf35AwzqQ1VQCBXToTPa0+E83pKjxcWs6Pf0wadZgxEfwmq7Y5SWehL9udN1kndVrK6QOC4O9fXfNhtMZwWtlr5XMx8Tsg8mvyf3tlBInkcJ/EOBK8cNtrNPuID4ksRE15zKAM=
Date: Tue, 6 Feb 2007 18:05:20 +0200
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 1/2] OSS: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206160520.GF8991@Ahmed>
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
[PATCH 1/2] compile-tested
[PATCH 2/2] couldn't be compile-tested (orphaned hardware ?)

diff --git a/sound/oss/es1371.c b/sound/oss/es1371.c
index cc282a0..e1fbcca 100644
--- a/sound/oss/es1371.c
+++ b/sound/oss/es1371.c
@@ -131,6 +131,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/mutex.h>
 #include <linux/mm.h>
+#include <linux/kernel.h>
 
 #include <asm/io.h>
 #include <asm/page.h>
@@ -2998,7 +2999,7 @@ static int __devinit es1371_probe(struct pci_dev *pcidev, const struct pci_devic
 	set_fs(KERNEL_DS);
 	val = SOUND_MASK_LINE;
 	mixdev_ioctl(s->codec, SOUND_MIXER_WRITE_RECSRC, (unsigned long)&val);
-	for (i = 0; i < sizeof(initvol)/sizeof(initvol[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(initvol); i++) {
 		val = initvol[i].vol;
 		mixdev_ioctl(s->codec, initvol[i].mixch, (unsigned long)&val);
 	}
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index a89108c..b92c8cd 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -32,6 +32,7 @@
 #include <linux/ctype.h>
 #include <linux/stddef.h>
 #include <linux/kmod.h>
+#include <linux/kernel.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 #include <linux/wait.h>
@@ -557,7 +558,7 @@ static int __init oss_init(void)
 	/* Protecting the innocent */
 	sound_dmap_flag = (dmabuf > 0 ? 1 : 0);
 
-	for (i = 0; i < sizeof (dev_list) / sizeof *dev_list; i++) {
+	for (i = 0; i < ARRAY_SIZE(dev_list); i++) {
 		device_create(sound_class, NULL,
 			      MKDEV(SOUND_MAJOR, dev_list[i].minor),
 			      "%s", dev_list[i].name);
@@ -581,7 +582,7 @@ static void __exit oss_cleanup(void)
 {
 	int i, j;
 
-	for (i = 0; i < sizeof (dev_list) / sizeof *dev_list; i++) {
+	for (i = 0; i < ARRAY_SIZE(dev_list); i++) {
 		device_destroy(sound_class, MKDEV(SOUND_MAJOR, dev_list[i].minor));
 		if (!dev_list[i].num)
 			continue;

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
