Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYHDRwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYHDRwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYHDRwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:52:03 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:35212 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYHDRwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:52:01 -0400
Date: Mon, 4 Aug 2008 13:50:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, axboe@kernel.dk
Subject: [PATCH] BLOCK: Simplify the Kconfig structure for the BLOCK layer.
Message-ID: <alpine.LFD.1.10.0808041347270.7208@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Given that everything in block/Kconfig and block/Kconfig.iosched
depends on "BLOCK", might as well just wrap the entire contents in a
single conditional and remove the unnecessary tests.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  unless there's something tricky or obscure that can happen in the
block layer that *doesn't* depend on BLOCK, this should be a
reasonable simplification.


 block/Kconfig         |    6 +++---
 block/Kconfig.iosched |    4 ----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/block/Kconfig b/block/Kconfig
index 1ab7c15..66cfacd 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -93,11 +93,11 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.

-endif # BLOCK
-
 config BLOCK_COMPAT
 	bool
-	depends on BLOCK && COMPAT
+	depends on COMPAT
 	default y

 source block/Kconfig.iosched
+
+endif # BLOCK
diff --git a/block/Kconfig.iosched b/block/Kconfig.iosched
index 7e803fc..5ada7f1 100644
--- a/block/Kconfig.iosched
+++ b/block/Kconfig.iosched
@@ -1,5 +1,3 @@
-if BLOCK
-
 menu "IO Schedulers"

 config IOSCHED_NOOP
@@ -69,5 +67,3 @@ config DEFAULT_IOSCHED
 	default "noop" if DEFAULT_NOOP

 endmenu
-
-endif

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
