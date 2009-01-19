Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZASRaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZASRaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZASR2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:28:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206AbZASR2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:28:04 -0500
Message-ID: <4974B98D.2020800@suse.de>
Date: Tue, 20 Jan 2009 01:34:05 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH 9/20] fs/hpfs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes hpfs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
---
 fs/hpfs/super.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index 0d049b8..c40f6e2 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -136,6 +136,7 @@ static int hpfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *s = dentry->d_sb;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	u64 id = huge_encode_dev(s->s_bdev->bd_dev);
 	lock_kernel();

 	/*if (sbi->sb_n_free == -1) {*/
@@ -149,6 +150,8 @@ static int hpfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = sbi->sb_n_free;
 	buf->f_files = sbi->sb_dirband_size / 4;
 	buf->f_ffree = sbi->sb_n_free_dnodes;
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = 254;

 	unlock_kernel();

-- 
Coly Li
SuSE Labs



