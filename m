Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbYKTLOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbYKTLOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYKTLOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:14:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbYKTLOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:14:00 -0500
Message-ID: <492545CC.6000909@cn.fujitsu.com>
Date: Thu, 20 Nov 2008 19:11:08 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       Hirokazu Takahashi <taka@valinux.co.jp>
CC: menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 3/7] Introduction for new feature
References: <4925445C.10302@cn.fujitsu.com>
In-Reply-To: <4925445C.10302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation of using bio-cgroup in io-throttle.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/controllers/io-throttle.txt |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
index 2a3bbd1..d3510ae 100644
--- a/Documentation/controllers/io-throttle.txt
+++ b/Documentation/controllers/io-throttle.txt
@@ -223,7 +223,34 @@ $ cat /proc/$$/io-throttle-stat
    \ \_______global bandwidth sleep (clock ticks)
     \________global bandwidth counter
 
-2.4. Examples
+2.4. Buffered-io tracking
+bio-cgroup can be used to track buffered-io(in delay-write condition) and for 
+proper throttling. You can directly mount io-throttle and bio-cgroup together 
+to track buffered-io. An alternative choice is making use of bio-cgroup id. An 
+association between a given io-throttle cgroup and a given bio-cgroup cgroup can 
+be built by echo a bio-cgroup id to the file blockio.bio_id. This file is exported 
+for the purpose of associating io-throttle and bio-cgroup groups. If you'd like to 
+create an association, you must ensure the io-throttle group is empty, that is, 
+there are no tasks in this group. otherwise, association creating will fail. If an 
+association is successfully built, task moving in this group will be denied. Of 
+course, you can remove an association, just echo an negative number into 
+blockio.bio_id.
+
+Example:
+* Create an association between a given io-throttle group and a given bio-cgroup 
+group.
+$ mount -t cgroup -o bio bio-cgroup /mnt/bio-cgroup/
+$ cd /mnt/bio-cgroup/
+$ mkdir bio-grp
+$ cat bio-grp/bio.id
+1
+
+$ mount -t cgroup -o blockio blockio /mnt/throttle
+$ cd /mnt/throttle
+$ mkdir foo
+$ echo 1 > foo/blockio.bio_id
+
+2.5. Examples
 
 * Mount the cgroup filesystem (blockio subsystem):
   # mkdir /mnt/cgroup
-- 1.5.4.rc3 

