Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYKOEYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYKOEYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYKOEYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:24:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49648 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYKOEYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:24:15 -0500
Date: Sat, 15 Nov 2008 13:23:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cmm@us.ibm.com, jack@ucw.cz, hch@lst.de
Subject: Re: mmotm 2008-11-14-17-14 uploaded
Message-Id: <20081115132333.8983c927.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
References: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 17:15:12 -0800
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2008-11-14-17-14 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> It contains the following patches against 2.6.28-rc4:
> 
I saw this.
==
fs/dquot.c:1391: error: redefinition of '__kcrctab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__kcrctab_dquot_reserve_space' was here
fs/dquot.c:1391: error: redefinition of '__kstrtab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__kstrtab_dquot_reserve_space' was here
fs/dquot.c:1391: error: redefinition of '__ksymtab_dquot_reserve_space'
fs/dquot.c:1352: error: previous definition of '__ksymtab_dquot_reserve_space' was here
fs/dquot.c:2101: error: redefinition of '__kcrctab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__kcrctab_vfs_dq_quota_on_remount' was here
fs/dquot.c:2101: error: redefinition of '__kstrtab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__kstrtab_vfs_dq_quota_on_remount' was here
fs/dquot.c:2101: error: redefinition of '__ksymtab_vfs_dq_quota_on_remount'
fs/dquot.c:1974: error: previous definition of '__ksymtab_vfs_dq_quota_on_remount' was here
make[1]: *** [fs/dquot.o] Error 1
==

and this may be a patch.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
==
---
 fs/dquot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: mmotm-2.6.28-Nov13/fs/dquot.c
===================================================================
--- mmotm-2.6.28-Nov13.orig/fs/dquot.c
+++ mmotm-2.6.28-Nov13/fs/dquot.c
@@ -1388,7 +1388,7 @@ int dquot_claim_space(struct inode *inod
 	inode_add_bytes(inode, number);
 	return ret;
 }
-EXPORT_SYMBOL(dquot_reserve_space);
+EXPORT_SYMBOL(dquot_claim_space);
 
 /*
  * Release reserved quota space
@@ -1971,7 +1971,7 @@ static int vfs_quota_on_remount(struct s
 
 	return ret;
 }
-EXPORT_SYMBOL(vfs_dq_quota_on_remount);
+EXPORT_SYMBOL(vfs_quota_on_remount);
 
 int vfs_quota_on_path(struct super_block *sb, int type, int format_id,
 		      struct path *path)
@@ -2277,6 +2277,7 @@ out:
 	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
 	return err;
 }
+EXPORT_SYMBOL(vfs_set_dqinfo);
 
 struct quotactl_ops vfs_quotactl_ops = {
 	.quota_on	= vfs_quota_on,


