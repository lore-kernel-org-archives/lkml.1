Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYIEFNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYIEFNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbYIEFNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:13:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51891 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbYIEFM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:12:59 -0400
Message-ID: <48C0BFA9.2000200@cn.fujitsu.com>
Date: Fri, 05 Sep 2008 13:12:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Paul Jackson <pj@sgi.com>, menage@google.com, linux-kernel@vger.kernel.org,
       jh@sgi.com
Subject: [PATCH -v2] cpuset: hotplug documentation fix
References: <48C0AAF8.605@cn.fujitsu.com> <20080904232958.6ac79ada.pj@sgi.com>
In-Reply-To: <20080904232958.6ac79ada.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If all the cpus in a cpuset are offlined, the tasks in it will
be moved to the nearest ancestor with non-empty cpus.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
---

fixed a typo: s/binded/bound

--
 Documentation/cpusets.txt |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/cpusets.txt b/Documentation/cpusets.txt
index 1f5a924..47e568a 100644
--- a/Documentation/cpusets.txt
+++ b/Documentation/cpusets.txt
@@ -635,14 +635,16 @@ prior 'mems' setting, will not be moved.
 
 There is an exception to the above.  If hotplug functionality is used
 to remove all the CPUs that are currently assigned to a cpuset,
-then the kernel will automatically update the cpus_allowed of all
-tasks attached to CPUs in that cpuset to allow all CPUs.  When memory
-hotplug functionality for removing Memory Nodes is available, a
-similar exception is expected to apply there as well.  In general,
-the kernel prefers to violate cpuset placement, over starving a task
-that has had all its allowed CPUs or Memory Nodes taken offline.  User
-code should reconfigure cpusets to only refer to online CPUs and Memory
-Nodes when using hotplug to add or remove such resources.
+then all the tasks in that cpuset will be moved to the nearest ancestor
+with non-empty cpus.  But the moving of some (or all) tasks might fail if
+cpuset is bound with another cgroup subsystem which has some restrictions
+on task attaching.  In this failing case, those tasks will stay
+in the original cpuset, and the kernel will automatically update
+their cpus_allowed to allow all online CPUs.  When memory hotplug
+functionality for removing Memory Nodes is available, a similar exception
+is expected to apply there as well.  In general, the kernel prefers to
+violate cpuset placement, over starving a task that has had all
+its allowed CPUs or Memory Nodes taken offline.
 
 There is a second exception to the above.  GFP_ATOMIC requests are
 kernel internal allocations that must be satisfied, immediately.
-- 
1.5.4.rc3

