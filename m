Return-Path: <linux-kernel-owner+w=401wt.eu-S1761104AbZC1XYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761104AbZC1XYp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZC1XYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:24:34 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:60666 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZC1XYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:24:33 -0400
Date: Sat, 28 Mar 2009 23:23:01 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Annotate struct fs_struct's usage count restriction
In-Reply-To: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils>
Message-ID: <Pine.LNX.4.64.0903282321390.15432@blonde.anvils>
References: <Pine.LNX.4.64.0903282307050.14892@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Annotate struct fs_struct's usage count to indicate the restrictions upon it.
It may not be incremented, except by clone(CLONE_FS), as this affects the
check in check_unsafe_exec() in fs/exec.c.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: stable@kernel.org
---

 include/linux/fs_struct.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- 2.6.29/include/linux/fs_struct.h	2009-03-23 23:12:14.000000000 +0000
+++ linux/include/linux/fs_struct.h	2009-03-28 18:06:02.000000000 +0000
@@ -4,7 +4,10 @@
 #include <linux/path.h>
 
 struct fs_struct {
-	atomic_t count;
+	atomic_t count;	/* This usage count is used by check_unsafe_exec() for
+			 * security checking purposes - therefore it may not be
+			 * incremented, except by clone(CLONE_FS).
+			 */
 	rwlock_t lock;
 	int umask;
 	struct path root, pwd;
