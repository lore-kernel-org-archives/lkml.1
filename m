Return-Path: <linux-kernel-owner+w=401wt.eu-S1422754AbXCGRNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422754AbXCGRNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXCGRNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:13:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:43343 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754AbXCGRN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:13:28 -0500
Message-Id: <20070307171119.945925964@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:10:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mark Fasheh <mark.fasheh@oracle.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 001/101] ocfs2: ocfs2_link() journal credits update
Content-Disposition: inline; filename=ocfs2-ocfs2_link-journal-credits-update.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 592282cf2eaa33409c6511ddd3f3ecaa57daeaaa fixed some missing directory
c/mtime updates in part by introducing a dinode update in ocfs2_add_entry().
Unfortunately, ocfs2_link() (which didn't update the directory inode before)
is now missing a single journal credit. Fix this by doubling the number of
inode updates expected during hard link creation.

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 fs/ocfs2/journal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/fs/ocfs2/journal.h
+++ linux-2.6.20.1/fs/ocfs2/journal.h
@@ -306,8 +306,8 @@ int                  ocfs2_journal_dirty
  * for the dinode, one for the new block. */
 #define OCFS2_SIMPLE_DIR_EXTEND_CREDITS (2)
 
-/* file update (nlink, etc) + dir entry block */
-#define OCFS2_LINK_CREDITS  (OCFS2_INODE_UPDATE_CREDITS + 1)
+/* file update (nlink, etc) + directory mtime/ctime + dir entry block */
+#define OCFS2_LINK_CREDITS  (2*OCFS2_INODE_UPDATE_CREDITS + 1)
 
 /* inode + dir inode (if we unlink a dir), + dir entry block + orphan
  * dir inode link */

--
