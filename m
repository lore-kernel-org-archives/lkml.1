Return-Path: <linux-kernel-owner+w=401wt.eu-S939954AbXFHH7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939954AbXFHH7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938428AbXFHHZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:25:45 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55394 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938008AbXFHHZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:25:43 -0400
Message-Id: <20070608072206.004104000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:21:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Christoph Lameter" <clameter@sgi.com>,
       Anton Altaparmakov <aia21@cantab.net>, Adrian Bunk <bunk@stusta.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 22/54] ntfs_init_locked_inode(): fix array indexing
Content-Disposition: inline; filename=ntfs_init_locked_inode-fix-array-indexing.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andrew Morton <akpm@linux-foundation.org>

Local variable `i' is a byte-counter.  Don't use it as an index into an array
of le32's.

Reported-by: "young dave" <hidave.darkstar@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>
Acked-by: Anton Altaparmakov <aia21@cantab.net>
Cc: <stable@kernel.org>
Cc: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ntfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.4.orig/fs/ntfs/inode.c
+++ linux-2.6.21.4/fs/ntfs/inode.c
@@ -141,7 +141,7 @@ static int ntfs_init_locked_inode(struct
 		if (!ni->name)
 			return -ENOMEM;
 		memcpy(ni->name, na->name, i);
-		ni->name[i] = 0;
+		ni->name[na->name_len] = 0;
 	}
 	return 0;
 }

-- 
