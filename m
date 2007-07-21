Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXGUD7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXGUD7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXGUD64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:58:56 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54633 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753334AbXGUD6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:58:54 -0400
Message-ID: <384990324.05232@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721035733.951838089@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 11:57:33 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] readahead cleanups and interleaved readahead take 2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

To save you from some merge conflicts, I rebased this readahead patchset
to 2.6.22-git5.

The following patches are based on yesterday's discussions, compiled and
tested OK.

smaller file_ra_state:
	[PATCH 1/8] compacting file_ra_state                                          
	[PATCH 2/8] mmap read-around simplification                                   
	[PATCH 3/8] combine file_ra_state.prev_index/prev_offset into prev_pos        

code cleanups:
	[PATCH 4/8] trivial filemap.c cleanups                                        
	[PATCH 5/8] remove several readahead macros                                   
	[PATCH 6/8] remove the limit max_sectors_kb imposed on max_readahead_kb       

support of interleaved reads:
	[PATCH 7/8] introduce radix_tree_scan_hole()                                  
	[PATCH 8/8] basic support of interleaved reads                                


The diffstat is

 block/ll_rw_blk.c          |    9 -----
 fs/ext3/dir.c              |    2 -
 fs/ext4/dir.c              |    2 -
 fs/splice.c                |    2 -
 include/linux/fs.h         |   14 +++-----
 include/linux/mm.h         |    2 -
 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   34 ++++++++++++++++++++
 mm/filemap.c               |   31 +++++++++---------
 mm/readahead.c             |   58 +++++++++++++++++++----------------
 10 files changed, 92 insertions(+), 64 deletions(-)

Regards,
Fengguang Wu
---
