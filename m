Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXGUErd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXGUErd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbXGUEoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:44:19 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49779 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750734AbXGUEnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:43:51 -0400
Message-ID: <384993019.23648@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070721044300.909424569@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 21 Jul 2007 12:43:00 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] readahead cleanups and interleaved readahead take 3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

The following patches are based on yesterday's discussions, compiled and
tested OK:

smaller file_ra_state:
	[PATCH 1/7] readahead: compacting file_ra_state
	[PATCH 2/7] readahead: mmap read-around simplification
	[PATCH 3/7] readahead: combine file_ra_state.prev_index/prev_offset into prev_

code cleanups:
	[PATCH 4/7] readahead: remove several readahead macros
	[PATCH 5/7] readahead: remove the limit max_sectors_kb imposed on max_readahead_kb

support of interleaved reads:
	[PATCH 6/7] radixtree: introduce radix_tree_scan_hole()
	[PATCH 7/7] readahead: basic support of interleaved reads

The diffstat is

 block/ll_rw_blk.c          |    9 -----
 fs/ext3/dir.c              |    2 -
 fs/ext4/dir.c              |    2 -
 fs/splice.c                |    2 -
 include/linux/fs.h         |   14 +++-----
 include/linux/mm.h         |    2 -
 include/linux/radix-tree.h |    2 +
 lib/radix-tree.c           |   34 ++++++++++++++++++++
 mm/filemap.c               |   17 +++++-----
 mm/readahead.c             |   58 +++++++++++++++++++----------------
 10 files changed, 86 insertions(+), 56 deletions(-)

Regards,
Fengguang Wu
--
