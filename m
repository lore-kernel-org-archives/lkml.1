Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbYJEQiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbYJEQiv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761262AbYJEQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:36:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35289 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758367AbYJEQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:36:33 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 06/19] hfsplus: O_LARGEFILE checking is missing
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:36:33 +0100
Message-ID: <20081005163630.3799.50442.stgit@localhost.localdomain>
In-Reply-To: <20081005163302.3799.61899.stgit@localhost.localdomain>
References: <20081005163302.3799.61899.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closes #8490
---

 fs/hfsplus/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index b085d64..963be64 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -254,6 +254,8 @@ static int hfsplus_file_open(struct inode *inode, struct file *file)
 {
 	if (HFSPLUS_IS_RSRC(inode))
 		inode = HFSPLUS_I(inode).rsrc_inode;
+	if (!(file->f_flags & O_LARGEFILE) && i_size_read(inode) > MAX_NON_LFS)
+		return -EOVERFLOW;
 	atomic_inc(&HFSPLUS_I(inode).opencnt);
 	return 0;
 }

