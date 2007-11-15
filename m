Return-Path: <linux-kernel-owner+w=401wt.eu-S1764175AbXKOQNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764175AbXKOQNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 11:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758269AbXKOQNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 11:13:39 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:22532 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759680AbXKOQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 11:13:38 -0500
Date: Thu, 15 Nov 2007 19:12:49 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] proc: use BUG_ON() in de_put()
Message-ID: <20071115161249.GE6216@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's much more visible that some printk. I still has an unexplained oops
in proc, so let's leave it for a while.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/inode.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -37,12 +37,7 @@ void de_put(struct proc_dir_entry *de)
 {
 	if (de) {	
 		lock_kernel();		
-		if (!atomic_read(&de->count)) {
-			printk("de_put: entry %s already free!\n", de->name);
-			unlock_kernel();
-			return;
-		}
-
+		BUG_ON(atomic_read(&de->count) == 0);
 		if (atomic_dec_and_test(&de->count)) {
 			if (de->deleted) {
 				printk("de_put: deferred delete of %s\n",

