Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbXLLVBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbXLLVBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbXLLVBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:01:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38097 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbXLLVBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:01:15 -0500
Date: Wed, 12 Dec 2007 15:01:07 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, reiserfs-dev@namesys.com,
       reiserfs-devel@vger.kernel.org
Subject: [RFC] [PATCH -mm] reiser4: replace uid==0 check with capability
Message-ID: <20071212210107.GB24708@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c257cb67ce00c8769730cfa92379a53009d99b28 Mon Sep 17 00:00:00 2001
From: serue@us.ibm.com <serue@us.ibm.com>
Date: Wed, 5 Dec 2007 14:02:45 -0800
Subject: [RFC] [PATCH -mm] reiser4: replace uid==0 check with capability

Reiser4 gives root some reserved blocks.  Replace the uid==0 check, which
is not safe in the face of user namespaces, with a CAP_SYS_RESOURCE check,
which seems appropriate.

The per-uid and per-guid reservations appear unimplemented so I'm ignoring
them.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/reiser4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiser4/super.c b/fs/reiser4/super.c
index bc4113e..50e3d09 100644
--- a/fs/reiser4/super.c
+++ b/fs/reiser4/super.c
@@ -144,7 +144,7 @@ long reiser4_reserved_blocks(const struct super_block *super	/* super block
 		reserved += reserved_for_gid(super, gid);
 	if (REISER4_SUPPORT_UID_SPACE_RESERVATION)
 		reserved += reserved_for_uid(super, uid);
-	if (REISER4_SUPPORT_ROOT_SPACE_RESERVATION && (uid == 0))
+	if (REISER4_SUPPORT_ROOT_SPACE_RESERVATION && capable(CAP_SYS_RESOURCE))
 		reserved += reserved_for_root(super);
 	return reserved;
 }
-- 
1.5.1

