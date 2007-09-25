Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbXIYIAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbXIYIAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXIYIAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:00:33 -0400
Received: from sacred.ru ([62.205.161.221]:35165 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbXIYIAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:00:33 -0400
Message-ID: <46F8BF79.40405@openvz.org>
Date: Tue, 25 Sep 2007 11:57:45 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: [PATCH] Fix messed hunks in generic_setlease
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 25 Sep 2007 12:00:09 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have noticed, that one hunk was lost and one duplicated 
during merging the fix-potential-oops-in-generic_setlease(-xxx) 
patches. One of the fixes is already in the hot-fixes, but the
second one is still lost.

The returned pointer was not the one allocated, but some temporary
used to scan through the inode's locks list. This caused and OOPS 
during Kamalesh's testing.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/fs/locks.c b/fs/locks.c
index c0fe71a..c1198e3 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1423,7 +1418,7 @@ int generic_setlease(struct file *filp, 
 	locks_copy_lock(new_fl, lease);
 	locks_insert_lock(before, new_fl);
 
-	*flp = fl;
+	*flp = new_fl;
 	return 0;
 
 out:

