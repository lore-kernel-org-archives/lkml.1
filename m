Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZIVE6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZIVE6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 00:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZIVE6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 00:58:24 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:38648 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104AbZIVE6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 00:58:21 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: [PATCH 3/3] documentation
Date: Tue, 22 Sep 2009 10:26:54 +0530
Message-Id: <1253595414-2855-4-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short guide on how to setup and use ramzswap.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>

---
 drivers/staging/ramzswap/ramzswap.txt |   51 +++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ramzswap/ramzswap.txt b/drivers/staging/ramzswap/ramzswap.txt
new file mode 100644
index 0000000..e9f1619
--- /dev/null
+++ b/drivers/staging/ramzswap/ramzswap.txt
@@ -0,0 +1,51 @@
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
+Individual ramzswap devices are configured and initialized using rzscontrol
+userspace utility as shown in examples below. See rzscontrol man page for more
+details.
+
+* Usage
+
+Following shows a typical sequence of steps for using ramzswap.
+
+1) Load Modules:
+	modprobe ramzswap num_devices=4
+	This creates 4 (uninitialized) devices: /dev/ramzswap{0,1,2,3}
+	(num_devices parameter is optional. Default: 1)
+
+2) Initialize:
+	Use rzscontrol utility to configure and initialize individual
+	ramzswap devices. Example:
+	rzscontrol /dev/ramzswap2 --init # uses default value of disksize_kb
+
+	*See rzscontrol man page for more details and examples*
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
