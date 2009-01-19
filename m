Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZASR1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZASR1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756493AbZASRZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:25:56 -0500
Received: from ns2.suse.de ([195.135.220.15]:49822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439AbZASRZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:25:54 -0500
Message-ID: <4974B910.1000509@suse.de>
Date: Tue, 20 Jan 2009 01:32:00 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.19 (X11/20090106)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Roman Zippel <zippel@linux-m68k.org>
Subject: [PATCH 3/20] fs/befs: return f_fsid for statfs(2)
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes befs return f_fsid info for statfs(2).

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Sergey S. Kostyliov <rathamahata@php4.ru>
---
 fs/befs/linuxvfs.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index d06cb02..76afd0d 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -900,6 +900,7 @@ static int
 befs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
+	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);

 	befs_debug(sb, "---> befs_statfs()");

@@ -910,6 +911,8 @@ befs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = 0;	/* UNKNOWN */
 	buf->f_ffree = 0;	/* UNKNOWN */
+	buf->f_fsid.val[0] = (u32)id;
+	buf->f_fsid.val[1] = (u32)(id >> 32);
 	buf->f_namelen = BEFS_NAME_LEN;

 	befs_debug(sb, "<--- befs_statfs()");

-- 
Coly Li
SuSE Labs



