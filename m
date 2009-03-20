Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZCTBrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZCTBrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 21:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbZCTBqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 21:46:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54472 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbZCTBqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 21:46:52 -0400
Message-ID: <49C2F599.3060306@cn.fujitsu.com>
Date: Fri, 20 Mar 2009 09:47:05 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] blktrace: various cleanups and fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to use blktrace in -tip tree, I encounted kernel NULL
dereference, so I looked into the code, and then found some other
bugs.

This patchset is part 1, and I have some other pending fixes.

Each patch is small and straightforward, and should be easy to review:

[PATCH 1/7] blktrace: fix possible memory leak
[PATCH 2/7] blktrace: make blk_tracer_enabled a bool flag
[PATCH 3/7] blktrace: remove blk_probe_mutex
[PATCH 4/7] blktrace: don't increase blk_probes_ref if failed to setup blk trace
[PATCH 5/7] blktrace: report EBUSY correctly
[PATCH 6/7] blktrace: remove sysfs_blk_trace_enable_show/store()
[PATCH 7/7] blktrace: avoid accessing NULL bdev->bd_disk
---
 blktrace.c |  154 +++++++++++++++++--------------------------------------------
 1 file changed, 45 insertions(+), 109 deletions(-)

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
