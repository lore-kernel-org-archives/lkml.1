Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753023AbYLQWOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbYLQWOr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:14:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYLQWOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:14:36 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40168 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbYLQWOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:14:35 -0500
Message-ID: <494979C6.7060003@sgi.com>
Date: Wed, 17 Dec 2008 14:14:30 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@redhat.com>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [PATCH 1/1]: sysfs: add documentation to cputopology.txt for system
 cpumasks
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216042646.088194000@polaris-admin.engr.sgi.com> <200812172223.53079.rusty@rustcorp.com.au> <20081217184011.GB30724@suse.de>
In-Reply-To: <20081217184011.GB30724@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sysfs: add documentation to cputopology.txt for system cpumasks

Add information to cputopology.txt explaining the output of various
system cpumask's.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 Documentation/cputopology.txt |   48 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- linux-2.6-for-ingo.orig/Documentation/cputopology.txt
+++ linux-2.6-for-ingo/Documentation/cputopology.txt
@@ -31,3 +31,51 @@ not defined by include/asm-XXX/topology.
 2) core_id: 0
 3) thread_siblings: just the given CPU
 4) core_siblings: just the given CPU
+
+Additionally, cpu topology information is provided under
+/sys/devices/system/cpu and includes these files.  The internal
+source for the output is in brackets ("[]").
+
+    kernel_max: the maximum cpu index allowed by the kernel configuration.
+		[NR_CPUS-1]
+
+    offline:	cpus that are not online because they have been
+		HOTPLUGGED off (see cpu-hotplug.txt) or exceed the limit
+		of cpus allowed by the kernel configuration (kernel_max
+		above). [~cpu_online_mask + cpus >= NR_CPUS]
+
+    online:	cpus that are online and being scheduled [cpu_online_mask]
+
+    possible:	cpus that have been allocated resources and can be
+		brought online if they are present. [cpu_possible_mask]
+
+    present:	cpus that have been identified as being present in the
+		system. [cpu_present_mask]
+
+The format for the above output is compatible with cpulist_parse()
+[see <linux/cpumask.h>].  Some examples follow.
+
+In this example, there are 64 cpus in the system but cpus 32-63 exceed
+the kernel max which is limited to 0..31 by the NR_CPUS config option
+being 32.  Note also that cpus 2 and 4-31 are not online but could be
+brought online as they are both present and possible.
+
+     kernel_max: 31
+        offline: 2,4-31,32-63
+         online: 0-1,3
+       possible: 0-31
+        present: 0-31
+
+In this example, the NR_CPUS config option is 128, but the kernel was
+started with possible_cpus=144.  There are 4 cpus in the system and cpu2
+was manually taken offline (and is the only cpu that can be brought
+online.)
+
+     kernel_max: 127
+        offline: 2,4-127,128-143
+         online: 0-1,3
+       possible: 0-127
+        present: 0-3
+
+See cpu-hotplug.txt for the possible_cpus=NUM kernel start parameter
+as well as more information on the various cpumask's.

