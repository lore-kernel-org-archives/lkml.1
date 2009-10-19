Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbZJSVee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbZJSVee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757945AbZJSVec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:34:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1780 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbZJSVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:34:31 -0400
Subject: [PATCH 5/5] Documentation: ABI: document /sys/devices/system/cpu/
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Date: Mon, 19 Oct 2009 15:34:35 -0600
Message-ID: <20091019213435.32729.81751.stgit@bob.kio>
In-Reply-To: <20091019212740.32729.7171.stgit@bob.kio>
References: <20091019212740.32729.7171.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface has been around for a long time, but hasn't been
officially documented.

Since I wanted to extend the ABI, I figured I would document what
already existed.

Cc: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-devices-cpu |   42 +++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-cpu

diff --git a/Documentation/ABI/testing/sysfs-devices-cpu b/Documentation/ABI/testing/sysfs-devices-cpu
new file mode 100644
index 0000000..9070889
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-cpu
@@ -0,0 +1,42 @@
+What:		/sys/devices/system/cpu/
+Date:		October 2009
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		A collection of CPU attributes, including cache information,
+		topology, and frequency. It also contains a mechanism to
+		logically hotplug CPUs.
+
+		The actual attributes present are architecture and
+		configuration dependent.
+
+
+What:		/sys/devices/system/cpu/$cpu/online
+Date:		January 2006
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:
+		When CONFIG_HOTPLUG_CPU is enabled, allows the user to
+		discover and change the online state of a CPU. To discover
+		the state:
+
+		cat /sys/devices/system/cpu/$cpu/online
+
+		A value of 0 indicates the CPU is offline. A value of 1
+		indicates it is online. To change the state, echo the
+		desired new state into the file:
+
+		echo [0|1] > /sys/devices/system/cpu/$cpu/online
+
+		For more information, please read Documentation/cpu-hotplug.txt
+
+
+What:		/sys/devices/system/cpu/$cpu/node
+Date:		October 2009
+Contact:	Linux memory management mailing list <linux-mm@kvack.org>
+Description:
+		When CONFIG_NUMA is enabled, a symbolic link that points
+		to the corresponding NUMA node directory.
+
+		For example, the following symlink is created for cpu42
+		in NUMA node 2:
+
+		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2

