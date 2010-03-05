Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0CECcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:32:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0CECcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:32:42 -0500
Message-ID: <4B906BDF.3090308@cn.fujitsu.com>
Date: Fri, 05 Mar 2010 10:26:39 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, jens.axboe@oracle.com
CC: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       Nauman Rafique <nauman@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2 V3] io-controller: Document for blkio.weight_device
References: <4B8DFFD7.2000908@cn.fujitsu.com> <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com>
In-Reply-To: <20100304152400.GB18786@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the document for blkio.weight_device

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 Documentation/cgroups/blkio-controller.txt |   35 +++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index 630879c..e551c85 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -76,7 +76,9 @@ CONFIG_DEBUG_BLK_CGROUP
 Details of cgroup files
 =======================
 - blkio.weight
-	- Specifies per cgroup weight.
+	- Specifies per cgroup weight. This is default weight of the group
+	  on all the devices until and unless overridden by per device rule.
+	  (See blkio.weight_device).
 
 	  Currently allowed range of weights is from 100 to 1000.
 
@@ -99,6 +101,37 @@ Details of cgroup files
 	  and minor number of the device and third field specifies the number
 	  of times a group was dequeued from a particular device.
 
+- blkio.weight_device
+	- One can specify per cgroup per device rules using this interface.
+	  These rules override the default value of group weight as specified
+	  by blkio.weight.
+
+	  Following is the format.
+
+	  #echo dev_maj:dev_minor weight > /pach/to/cgroup/blkio.weight_device
+
+	  weight=0 means removing weight on a given device.
+
+	  Examples:
+	  Configure weight=300 on /dev/sdb (8:16) in this cgroup
+	  # echo 8:16 300 > blkio.weight_device
+	  # cat blkio.weight_device
+	  dev     weight
+	  8:16    300
+
+	  Configure weight=500 on /dev/sda (8:0) in this cgroup
+	  # echo 8:0 500 > blkio.weight_device
+	  # cat blkio.weight_device
+	  dev     weight
+	  8:0     500
+	  8:16    300
+
+	  Remove specific weight for /dev/sda in this cgroup
+	  # echo 8:0 0 > blkio.weight_device
+	  # cat blkio.weight_device
+	  dev     weight
+	  8:16    300
+
 CFQ sysfs tunable
 =================
 /sys/block/<disk>/queue/iosched/group_isolation
-- 
1.5.4.rc3




