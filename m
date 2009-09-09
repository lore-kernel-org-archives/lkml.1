Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZIIWD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZIIWD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 18:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZIIWD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 18:03:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:13259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZIIWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 18:03:55 -0400
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] documentation
Date: Thu, 10 Sep 2009 02:51:45 +0530
User-Agent: KMail/1.12.0 (Linux/2.6.30.5-43.fc11.x86_64; KDE/4.3.0; x86_64; ; )
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
References: <200909100215.36350.ngupta@vflare.org>
In-Reply-To: <200909100215.36350.ngupta@vflare.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909100251.45074.ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short guide on how to setup and use ramzswap.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
---

 Documentation/blockdev/00-INDEX     |    2 +
 Documentation/blockdev/ramzswap.txt |   50 +++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
index c08df56..c1cb074 100644
--- a/Documentation/blockdev/00-INDEX
+++ b/Documentation/blockdev/00-INDEX
@@ -16,3 +16,5 @@ paride.txt
 	- information about the parallel port IDE subsystem.
 ramdisk.txt
 	- short guide on how to set up and use the RAM disk.
+ramzswap.txt
+	- short guide on how to setup compressed in-memory swap device.
diff --git a/Documentation/blockdev/ramzswap.txt b/Documentation/blockdev/ramzswap.txt
new file mode 100644
index 0000000..b026715
--- /dev/null
+++ b/Documentation/blockdev/ramzswap.txt
@@ -0,0 +1,50 @@
+ramzswap: Compressed RAM based swap device
+-------------------------------------------
+
+Project home: http://compcache.googlecode.com/
+
+* Introduction
+
+It creates RAM based block devices which can be used (only) as swap disks.
+Pages swapped to these devices are compressed and stored in memory itself.
+See project home for use cases, performance numbers and a lot more.
+
+The configuration parameters for individual ramzswap devices are set using
+rzscontrol userspace utility as shown below.
+
+* Usage
+
+Following shows a typical sequence of steps for using ramzswap.
+
+1) Load Modules:
+	modprobe ramzswap NUM_DEVICES=4
+	This creates 4 (uninitialized) devices: /dev/ramzswap{0,1,2,3}
+	(NUM_DEVICES parameter is optional. Default: 1)
+
+2) Initialize:
+	Use rzscontrol utility to configure and initialize individual
+	ramzswap devices. Example:
+	rzscontrol /dev/ramzswap2 --init # uses default value of disksize_kb
+
+	*See rzscontrol manpage for more details and examples*
+
+3) Activate:
+	swapon /dev/ramzswap2 # or any other initialized ramzswap device
+
+4) Stats:
+	rzscontrol /dev/ramzswap2 --stats
+
+5) Deactivate:
+	swapoff /dev/ramzswap2
+
+6) Reset:
+	rzscontrol /dev/ramzswap2 --reset
+	(This frees all the memory allocated for this device).
+
+
+Please report any problems at:
+ - Mailing list: linux-mm-cc at laptop dot org
+ - Issue tracker: http://code.google.com/p/compcache/issues/list
+
+Nitin Gupta
+ngupta@vflare.org
