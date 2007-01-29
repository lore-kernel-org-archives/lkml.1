Return-Path: <linux-kernel-owner+w=401wt.eu-S1751093AbXA2UB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbXA2UB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXA2UB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:01:29 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:43115 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXA2UB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:01:28 -0500
Message-ID: <45BE5297.4070608@kernel.org>
Date: Mon, 29 Jan 2007 12:01:27 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] cdev.h needs struct inode; add forward declaration
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/cdev.h defines cd_forget to take a struct inode *, but does not
pull in any definition or declaration for struct inode.  This generates a
compiler warning if a source file pulls in cdev.h without first pulling in
fs.h.  Add a forward declaration of struct inode to cdev.h, to eliminate the
compiler warning and preserve the ability to include headers in any arbitrary
order.

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 include/linux/cdev.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index f309b00..4281e80 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -6,6 +6,8 @@
 #include <linux/kdev_t.h>
 #include <linux/list.h>
 
+struct inode;
+
 struct cdev {
 	struct kobject kobj;
 	struct module *owner;
