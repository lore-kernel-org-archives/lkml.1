Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0CCG2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 01:28:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50086 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0CCG2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 01:28:09 -0500
Message-ID: <4B8E000F.7050207@cn.fujitsu.com>
Date: Wed, 03 Mar 2010 14:22:07 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] io-controller: Document for blkio.policy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the document for blkio.policy.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/cgroups/blkio-controller.txt |   35 +++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 630879c..f29f206 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -76,7 +76,9 @@ CONFIG_DEBUG_BLK_CGROUP
 Details of cgroup files
 =======================
 - blkio.weight
-	- Specifies per cgroup weight.
+	- Specifies per cgroup weight. This is default weight of the group
+	  on all the devices until and unless overridden by per device rule.
+	  (See blkio.policy).
 
 	  Currently allowed range of weights is from 100 to 1000.
 
@@ -99,6 +101,37 @@ Details of cgroup files
 	  and minor number of the device and third field specifies the number
 	  of times a group was dequeued from a particular device.
 
+- blkio.policy
+	- One can specify per cgroup per device rules using this interface.
+	  These rules override the default value of group weight as specified
+	  by blkio.weight.
+
+	  Following is the format.
+
+	  #echo dev_maj:dev_minor weight > /patch/to/cgroup/blkio.policy
+
+	  weight=0 means removing a policy.
+
+	  Examples:
+	  Configure weight=300 on /dev/sdb (8:16) in this cgroup
+	  # echo 8:16 300 > blkio.policy
+	  # cat blkio.policy
+	  dev     weight
+	  8:16    300
+
+	  Configure weight=500 on /dev/sda (8:0) in this cgroup
+	  # echo 8:0 500 > blkio.policy
+	  # cat blkio.policy
+	  dev     weight
+	  8:0     500
+	  8:16    300
+
+	  Remove the policy for /dev/sda in this cgroup
+	  # echo 8:0 0 > blkio.policy
+	  # cat blkio.policy
+	  dev     weight
+	  8:16    300
+
 CFQ sysfs tunable
 =================
 /sys/block/<disk>/queue/iosched/group_isolation
-- 
1.5.4.rc3




