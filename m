Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZJBL6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZJBL6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZJBL6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:58:40 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:37931 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZJBL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:58:39 -0400
Date: Fri, 02 Oct 2009 20:58:43 +0900 (JST)
Message-Id: <20091002.205843.183050041.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: [PATCH 7/9] blkio-cgroup-v13: The document of blkio-cgroup
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20091002.205817.112597159.ryov@valinux.co.jp>
References: <20091002.205725.104059507.ryov@valinux.co.jp>
	<20091002.205748.189700030.ryov@valinux.co.jp>
	<20091002.205817.112597159.ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The document of blkio-cgroup.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 Documentation/cgroups/00-INDEX  |    2 +
 Documentation/cgroups/blkio.txt |   49 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

Index: linux-2.6.32-rc1/Documentation/cgroups/00-INDEX
===================================================================
--- linux-2.6.32-rc1.orig/Documentation/cgroups/00-INDEX
+++ linux-2.6.32-rc1/Documentation/cgroups/00-INDEX
@@ -16,3 +16,5 @@ memory.txt
 	- Memory Resource Controller; design, accounting, interface, testing.
 resource_counter.txt
 	- Resource Counter API.
+blkio.txt
+	- Block I/O Tracking; description, interface and examples.
Index: linux-2.6.32-rc1/Documentation/cgroups/blkio.txt
===================================================================
--- /dev/null
+++ linux-2.6.32-rc1/Documentation/cgroups/blkio.txt
@@ -0,0 +1,49 @@
+Block I/O Cgroup
+
+1. Overview
+
+Using this feature the owners of any type of I/O can be determined.
+This allows dm-ioband to control block I/O bandwidth even when it is
+accepting delayed write requests. dm-ioband can find the cgroup of
+each request. It is also for possible that others working on I/O
+bandwidth throttling to use this functionality to control asynchronous
+I/O with a little enhancement.
+
+2. Setting up blkio-cgroup
+
+The following kernel config options are required.
+
+CONFIG_CGROUPS=y
+CONFIG_CGROUP_BLKIO=y
+
+Selecting the options for the cgroup memory subsystem is also recommended
+as it makes it possible to give some I/O bandwidth and memory to a selected
+cgroup to control delayed write requests. The amount of dirty pages is
+limited within the cgroup even if the allocated bandwidth is narrow.
+
+CONFIG_RESOURCE_COUNTERS=y
+CONFIG_CGROUP_MEM_RES_CTLR=y
+
+3. User interface
+
+3.1 Mounting the cgroup filesystem
+
+First, mount the cgroup filesystem in order to enable observation and
+modification of the blkio-cgroup settings.
+
+# mount -t cgroup -o blkio none /cgroup
+
+3.2 The blkio.id file
+
+After mounting the cgroup filesystem the blkio.id file will be visible
+in the cgroup directory. This file contains a unique ID number for
+each cgroup. When an I/O operation starts, blkio-cgroup sets the
+page's ID number on the page cgroup. The cgroup of I/O can be
+determined by retrieving the ID number from the page cgroup, because
+the page cgroup is associated with the page which is involved in the
+I/O.
+
+4. Contact
+
+Linux Block I/O Bandwidth Control Project
+http://sourceforge.net/projects/ioband/
