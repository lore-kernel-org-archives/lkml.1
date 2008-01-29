Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYA2Dej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYA2Dej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 22:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbYA2De2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 22:34:28 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:60411 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYA2De1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 22:34:27 -0500
Date: Mon, 28 Jan 2008 19:33:07 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Joel Becker <Joel.Becker@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [git pull] Fix recent Ocfs2 breakage
Message-ID: <20080129033307.GE23506@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg's commit c60b71787982cefcf9fa09aa281fa8c4c685d557 inadvertantly broke
Ocfs2 userspace ABI, so I have a rather high priority single line patch from
Joel to fix things up for you to pull. A copy of the patch is attached to
the bottom of this e-mail. Embarassingly enough, I missed this while acking
the patch late last week :(

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/ocfs2/cluster/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Joel Becker (1):
      ocfs2: Fix userspace ABI breakage in sysfs


From: Joel Becker <Joel.Becker@oracle.com>

ocfs2: Fix userspace ABI breakage in sysfs

The userspace ABI of ocfs2's internal cluster stack (o2cb) was broken by
commit c60b71787982cefcf9fa09aa281fa8c4c685d557 "kset: convert ocfs2 to
use kset_create".  Specifically, the '/sys/o2cb' kset was moved to
'/sys/fs/o2cb'.  This breaks all ocfs2 tools and renders the
filesystem unmountable.

This fix moves '/sys/o2cb' back where it belongs.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
---
 fs/ocfs2/cluster/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
index a4b0773..0c095ce 100644
--- a/fs/ocfs2/cluster/sys.c
+++ b/fs/ocfs2/cluster/sys.c
@@ -64,7 +64,7 @@ int o2cb_sys_init(void)
 {
 	int ret;
 
-	o2cb_kset = kset_create_and_add("o2cb", NULL, fs_kobj);
+	o2cb_kset = kset_create_and_add("o2cb", NULL, NULL);
 	if (!o2cb_kset)
 		return -ENOMEM;
 
-- 
1.5.3.6

