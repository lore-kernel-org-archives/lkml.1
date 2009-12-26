Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZLZAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZLZAbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZLZAbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:31:22 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40911 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZLZAbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:31:21 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v3 0/4] cgroup notifications API and memory thresholds
Date: Sat, 26 Dec 2009 02:30:56 +0200
Message-Id: <cover.1261786326.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces eventfd-based API for notifications in cgroups and
implements memory notifications on top of it.

It uses statistics in memory controler to track memory usage.

Output of time(1) on building kernel on tmpfs:

Root cgroup before changes:
	make -j2  506.37 user 60.93s system 193% cpu 4:52.77 total
Non-root cgroup before changes:
	make -j2  507.14 user 62.66s system 193% cpu 4:54.74 total
Root cgroup after changes (0 thresholds):
	make -j2  507.13 user 62.20s system 193% cpu 4:53.55 total
Non-root cgroup after changes (0 thresholds):
	make -j2  507.70 user 64.20s system 193% cpu 4:55.70 total
Root cgroup after changes (1 thresholds, never crossed):
	make -j2  506.97 user 62.20s system 193% cpu 4:53.90 total
Non-root cgroup after changes (1 thresholds, never crossed):
	make -j2  507.55 user 64.08s system 193% cpu 4:55.63 total

Any comments?

v2 -> v3:
 - remove [RFC];
 - rebased to 2.6.33-rc2;
 - fixes based on comments;
 - fixed potential race on event removing;
 - use RCU-protected arrays to track trasholds.

v1 -> v2:
 - use statistics instead of res_counter to track resource usage;
 - fix bugs with locking.

v0 -> v1:
 - memsw support implemented.

Kirill A. Shutemov (4):
  cgroup: implement eventfd-based generic API for notifications
  memcg: extract mem_group_usage() from mem_cgroup_read()
  memcg: rework usage of stats by soft limit
  memcg: implement memory thresholds

 include/linux/cgroup.h |   24 ++++
 kernel/cgroup.c        |  208 ++++++++++++++++++++++++++++-
 mm/memcontrol.c        |  348 ++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 552 insertions(+), 28 deletions(-)

