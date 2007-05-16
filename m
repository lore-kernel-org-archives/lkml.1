Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXEPWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXEPWs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 18:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbXEPWsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 18:48:35 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:50145 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758450AbXEPWsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 18:48:33 -0400
Message-ID: <379355695.13712@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070516224752.500812933@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Thu, 17 May 2007 06:47:52 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH 0/9] on-demand readahead
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This is the standalone on-demand readahead patchset that applies to
linux-2.6.22-rc1-mm1. It _replaces_ the current readahead algorithm with
the on-demand readahead algorithm that was first introduced in mail
http://lkml.org/lkml/2007/4/25/182.

patchset:

[PATCH 1/9] readahead: introduce PG_readahead
[PATCH 2/9] readahead: add look-ahead support to __do_page_cache_readahead()
[PATCH 3/9] readahead: MIN_RA_PAGES/MAX_RA_PAGES macros
[PATCH 4/9] readahead: data structure and routines
[PATCH 5/9] readahead: on-demand readahead logic
[PATCH 6/9] readahead: convert filemap invocations
[PATCH 7/9] readahead: convert splice invocations
[PATCH 8/9] readahead: convert ext3/ext4 invocations
[PATCH 9/9] readahead: remove the old algorithm

diffstat:

 fs/ext3/dir.c              |   14
 fs/ext4/dir.c              |   14
 fs/splice.c                |   18 -
 include/linux/fs.h         |   73 ++++-
 include/linux/mm.h         |    5
 include/linux/page-flags.h |    5
 mm/filemap.c               |   51 ++-
 mm/page_alloc.c            |    2
 mm/readahead.c             |  511 +++++++++++++----------------------
 9 files changed, 322 insertions(+), 371 deletions(-)

Regards,
Fengguang Wu
--
