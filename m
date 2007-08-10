Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbXHJGeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbXHJGeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 02:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXHJGe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 02:34:26 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:53348 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751977AbXHJGeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 02:34:25 -0400
Message-ID: <386727659.27809@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070810063412.238042387@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 14:34:12 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Ken Chen <kenchen@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/4] [RFC][PATCH] fs-writeback: redefining the dirty inode queues
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I'd like to propose a cleaner way of using the s_dirty, s_io, s_more_io
queues for the writeback of dirty inodes. The basic idea is to clearly
define the function of the queues, especially to decouple s_diry from
s_io/s_more_io.  The details are in the changelog of patch 2.

The patches are some cleanups on top of Andrew's s_dirty time-ordering
patches and Ken's s_more_io patch:

[PATCH 1/4] writeback: check time-ordering of s_io and s_more_io
[PATCH 2/4] writeback: 3-queue based writeback schedule
[PATCH 3/4] writeback: function renames and cleanups
[PATCH 4/4] writeback: fix ntfs with sb_has_dirty_inodes()

 fs/fs-writeback.c  |  196 +++++++++++++++++++++++--------------------
 fs/ntfs/super.c    |    4 
 include/linux/fs.h |    1 
 3 files changed, 108 insertions(+), 93 deletions(-)

Note that the patches need rework for inserting into the right place of
your queue of -mm patches. I'll take care of it in the next take.

Thank you,
Fengguang
-- 
