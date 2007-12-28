Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbXL1Nws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbXL1Nws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 08:52:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXL1Nvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 08:51:33 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:44487 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752966AbXL1Nv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 08:51:28 -0500
Message-ID: <398849893.11859@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071228134119.112899193@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 28 Dec 2007 21:41:19 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Rubin <mrubin@google.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] writeback bug fixes and simplifications
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Here are some writeback bug fixes and code cleanups, based on 2.6.24-rc6-mm1.

The detailed description can be found in the first patch, which introduces the
new facility for the following patches to use.

The first two patches combined should fix the "slow writes for concurrent large
and small file writes" bug which Michael Rubin tries to fix.

[PATCH 01/11] writeback: introduce s_more_io_wait for inodes to be re-synced af
[PATCH 02/11] writeback: requeue_io_wait() on blocked kupdate
[PATCH 03/11] writeback: replace redirty_tail() on more-pages-to-sync
[PATCH 04/11] writeback: requeue_io_wait() on locked inode
[PATCH 05/11] writeback: requeue_io_wait() on congested blockdev
[PATCH 06/11] writeback: requeue_io_wait() on locked buffers
[PATCH 07/11] writeback: requeue_io() on redirtied inode

More code cleanups:

[PATCH 08/11] writeback: introduce queue_dirty()
[PATCH 09/11] writeback: replace redirty_tail() on memory-backed bdi
[PATCH 10/11] writeback: remove redirty_tail()
[PATCH 11/11] writeback: __sync_single_inode() code cleanup


Diffstat:

 fs/fs-writeback.c         |  125 +++++++++++++-----------------------
 fs/super.c                |    1
 include/linux/fs.h        |    1
 include/linux/writeback.h |    1
 mm/page-writeback.c       |   56 +++++++++-------
 5 files changed, 82 insertions(+), 102 deletions(-)

Thank you,
Fengguang
--
