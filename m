Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbZJ1Svo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbZJ1Svo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 14:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZJ1Svn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 14:51:43 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39415 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZJ1Svj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 14:51:39 -0400
Subject: Driver-Core: devtmpfs - cleanup node on device creation error
From: Kay Sievers <kay.sievers@vrfy.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Oct 2009 19:51:37 +0100
Message-Id: <1256755897.2618.324.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Driver-Core: devtmpfs - cleanup node on device creation error

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/base/core.c |    2 ++
 1 file changed, 2 insertions(+)

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

