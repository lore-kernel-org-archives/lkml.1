Return-Path: <linux-kernel-owner+w=401wt.eu-S1761834AbZAUFVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834AbZAUFVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbZAUFVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:21:11 -0500
Received: from kroah.org ([198.145.64.141]:53320 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751078AbZAUFVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:21:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/5] sysfs: fix problems with binary files
Date: Tue, 20 Jan 2009 21:19:55 -0800
Message-Id: <1232515197-3974-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090121051855.GA3665@kroah.com>
References: <20090121051855.GA3665@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some sysfs binary files don't like having 0 passed to them as a size.
Fix this up at the root by just returning to the vfs if userspace asks
us for a zero sized buffer.

Thanks to Pavel Roskin for pointing this out.

Reported-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 66f6e58..f2c478c 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -63,6 +63,9 @@ read(struct file *file, char __user *userbuf, size_t bytes, loff_t *off)
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;
 
+	if (!bytes)
+		return 0;
+
 	if (size) {
 		if (offs > size)
 			return 0;
@@ -131,6 +134,9 @@ static ssize_t write(struct file *file, const char __user *userbuf,
 	int count = min_t(size_t, bytes, PAGE_SIZE);
 	char *temp;
 
+	if (!bytes)
+		return 0;
+
 	if (size) {
 		if (offs > size)
 			return 0;
-- 
1.6.0.4

