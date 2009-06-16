Return-Path: <linux-kernel-owner+w=401wt.eu-S936254AbZFPF6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936254AbZFPF6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935807AbZFPFvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:22 -0400
Received: from kroah.org ([198.145.64.141]:48387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935580AbZFPFvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:19 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/64] Driver Core: sound: add nodename for sound drivers
Date: Mon, 15 Jun 2009 22:46:21 -0700
Message-Id: <1245131213-24168-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

This adds support to the sound core to report the proper device name to
userspace for their devices.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/sound_core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/sound/sound_core.c b/sound/sound_core.c
index 2b302bb..12522e6 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -27,6 +27,11 @@ MODULE_DESCRIPTION("Core sound module");
 MODULE_AUTHOR("Alan Cox");
 MODULE_LICENSE("GPL");
 
+static char *sound_nodename(struct device *dev)
+{
+	return kasprintf(GFP_KERNEL, "snd/%s", dev_name(dev));
+}
+
 static int __init init_soundcore(void)
 {
 	int rc;
@@ -41,6 +46,8 @@ static int __init init_soundcore(void)
 		return PTR_ERR(sound_class);
 	}
 
+	sound_class->nodename = sound_nodename;
+
 	return 0;
 }
 
-- 
1.6.3.2

