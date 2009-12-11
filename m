Return-Path: <linux-kernel-owner+w=401wt.eu-S934274AbZLKWd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934274AbZLKWd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbZLKWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:04 -0500
Received: from kroah.org ([198.145.64.141]:32772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761569AbZLKWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/27] Driver Core: devtmpfs: cleanup node on device creation error
Date: Fri, 11 Dec 2009 14:24:29 -0800
Message-Id: <1260570289-6997-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 6bee6af..0d3c29d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -987,6 +987,8 @@ done:
 	device_remove_class_symlinks(dev);
  SymlinkError:
 	if (MAJOR(dev->devt))
+		devtmpfs_delete_node(dev);
+	if (MAJOR(dev->devt))
 		device_remove_sys_dev_entry(dev);
  devtattrError:
 	if (MAJOR(dev->devt))
-- 
1.6.5.5

