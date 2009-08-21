Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZHUG4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZHUG4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbZHUGz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:55:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152AbZHUGz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:55:56 -0400
Date: Fri, 21 Aug 2009 02:55:34 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090821065759.4855.24212.sendpatchset@localhost.localdomain>
In-Reply-To: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
Subject: [Patch 8/8] doc: update the kdump document
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Update the document for kdump.

Signed-off-by: WANG Cong <amwang@redhat.com>

---

Index: linux-2.6/Documentation/kdump/kdump.txt
===================================================================
--- linux-2.6.orig/Documentation/kdump/kdump.txt
+++ linux-2.6/Documentation/kdump/kdump.txt
@@ -147,6 +147,15 @@ System kernel config options
    analysis tools require a vmlinux with debug symbols in order to read
    and analyze a dump file.
 
+4) Enable "automatically reserve memory for kexec kernel" in
+   "Processor type and features."
+
+   CONFIG_KEXEC_AUTO_RESERVE=y
+
+   This will let you to use "crashkernel=auto", instead of specifying
+   numbers for "crashkernel=". Note, you need to have enough memory.
+   The threshold and reserved memory size are arch-dependent.
+
 Dump-capture kernel config options (Arch Independent)
 -----------------------------------------------------
 
@@ -266,6 +275,25 @@ This would mean:
     2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
     3) if the RAM size is larger than 2G, then reserve 128M
 
+Or you can use:
+
+    crashkernel=auto
+
+if you have enough memory. The threshold is 4G, below which this won't work.
+
+The automatically reserved memory size would be 128M on x86_32, 256M on
+ppc, 1/32 of your physical memory size on x86_64 and ppc64 (but it will not
+exceed 1TB/32 if you have more). IA64 has its own policy, shown below:
+
+	Memory size	Reserved memory
+	===========	===============
+	[4G, 12G)	256M
+	[12G, 128G)	512M
+	[128G, 256G)	768M
+	[256G, 378G)	1024M
+	[378G, 512G)	1536M
+	[512G, 768G)	2048M
+	[768G, )	3072M
 
 
 Boot into System Kernel
