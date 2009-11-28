Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZK1G1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZK1G1d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 01:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZK1G1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 01:27:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:53404 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751380AbZK1G1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 01:27:31 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX19shA5Jl4psLPwSVmP9aeHLe2Mv0TScMAhQGhU/5v
	PwvNNV7QZlCqp1
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Cc: Johannes Buchner <buchner.johannes@gmx.at>
Subject: [PATCH 0/4] reiser4 fixes for -mm
Date: Sat, 28 Nov 2009 19:28:00 +1300
Message-Id: <1259389684-18625-1-git-send-email-buchner.johannes@gmx.at>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
References: <1259389179-3772-2-git-send-email-buchner.johannes@gmx.at>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the same patches as a previous email with the subject
'Re: Fw: reiser4 git repo', but without MIME.

The content of my previous mail:

> I had some issues with the reiser4 patch series from -mm.
> First of all, I'm not sure what release they are based on. I used 
> a8a8a669e from Linus' git repository. I applied all reiser4 patches
> (except reiser4-disable of course) from
> http://userweb.kernel.org/~akpm/mmotm/, which worked fine.
> 
> I think these patches are based on the reiser4-2.6.30 patch. 
> I also compared them to the reiser4-2.6.31 patch, which adds some
> missing pieces ([1] reiser4-from-2.6.31-patch.patch).
> 
> Additionally, some recent commits demand some changes, especially
> since current_is_pdflush and generic_sync_sb_inodes are not available
> any more (d8a8559cd7a9cc).
> [2] reiser4-pdflush-comments.patch only fixes some comments which
> still mention pdflush. 
> In [3] reiser4-generic_sync_sb_inodes.patch I tried to
> replace generic_sync_sb_inodes. I am not 100% sure that this is
> correct, but that is what I understood from the commit diff+message of
> d8a8559cd7a9cc.
> 
> The original patch
> 'reiser4-vfs-add-super_operationssync_inodes' introduced the call from
> sync_inodes_sb to the super operation sync_inodes(sb, NULL). This NULL
> pointer is dereferenced in reiser4_sync_inodes, which is fixed by
> [4] reiser4-sync_inodes-null-dereference.patch.
> 
> All 4 additional patches are attached. I can only say that it works on
> my machine, before I had compilation issues and freezes on 'sync'. 
> 
> Cheers,
> Johannes
> 
> PS: The git repo mentioned in
> http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt is not
> available.


Johannes Buchner (4):
  reiser4: some changes from reiser4-2.6.31 patch
  reiser4: some comments were still mentioning pdflush
  reiser4: generic_sync_sb_inodes doesn't exist anymore
  reiser4: fixed null pointer dereference

 fs/reiser4/carry.c     |    2 +-
 fs/reiser4/carry_ops.c |    2 +-
 fs/reiser4/context.c   |    2 +-
 fs/reiser4/coord.c     |    8 ++++----
 fs/reiser4/entd.c      |    4 +++-
 fs/reiser4/super_ops.c |    6 ++++--
 fs/reiser4/txnmgr.c    |    4 ++--
 fs/reiser4/znode.h     |    1 -
 include/linux/mm.h     |    1 +
 mm/filemap.c           |    4 +++-
 mm/page-writeback.c    |   26 ++++++++++++++++++++++++++
 11 files changed, 46 insertions(+), 14 deletions(-)

