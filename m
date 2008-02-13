Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbYBMWWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbYBMWWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBMWWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:22:15 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:27224 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbYBMWWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aywLFm532vVt5zmgYjrwk1ygMmT9mIgTo3YmPfHfbrFLOeVu5WzLWDRj8XuYWZC7ZPQRvBRexZSsdqhlLmlMm2rNmUwwW18MZGbbKmArI5L2DFDcdM9E1IMlVZAtMAgzwUhC5+oIb1z4yZwQZM8Wtp3zdzLXOepkZOglzS7SRyI=
Subject: [RFC PATCH] feature-removal: add documentation for exported
	symbols going away
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Emelyanov <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 14:22:06 -0800
Message-Id: <1202941327.18204.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 Documentation/feature-removal-schedule.txt         |   10 ------
 Documentation/feature-removal/exported-symbols.txt |   34 ++++++++++++++++++++
 arch/x86/kernel/io_delay.c                         |    2 +-
 net/ipv4/inet_hashtables.c                         |    2 +-
 4 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 4d3aa51..b09b193 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -118,16 +118,6 @@ Who:    Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
-What:	Unused EXPORT_SYMBOL/EXPORT_SYMBOL_GPL exports
-	(temporary transition config option provided until then)
-	The transition config option will also be removed at the same time.
-When:	before 2.6.19
-Why:	Unused symbols are both increasing the size of the kernel binary
-	and are often a sign of "wrong API"
-Who:	Arjan van de Ven <arjan@linux.intel.com>
-
----------------------------
-
 What:	vm_ops.nopage
 When:	Soon, provided in-kernel callers have been converted
 Why:	This interface is replaced by vm_ops.fault, but it has been around
diff --git a/Documentation/feature-removal/exported-symbols.txt b/Documentation/feature-removal/exported-symbols.txt
new file mode 100644
index 0000000..c847792
--- /dev/null
+++ b/Documentation/feature-removal/exported-symbols.txt
@@ -0,0 +1,34 @@
+The following is a list of symbols whose exports are unused in the kernel
+tree and will be removed.  Unused symbols are both increasing the size of
+the kernel binary and are often a sign of a "wrong API"
+
+When adding a symbol, change to EXPORT_UNUSED_SYMBOL{_GPL} in the source
+and schedule for removal in the first stable version the unused symbol is
+marked in + 3.  This will give out of tree code ~9 months to stop using the
+export or make a case why the export should be kept.
+
+CONFIG_UNUSED_SYMBOLS is provided to enable unused symbol exports.
+
+Please include the following:
+
+What:	the_symbol
+Where:	filename the symbol is exported from
+When:	next stable version+3
+Why:	a reason would be nice
+
+---------------------------
+
+What:	__inet_hash_connect
+Where:	net/ipv4/inet_hashtables.c
+When:	2.6.28
+Why:	No in tree users
+
+---------------------------
+
+What:	io_delay_type
+Where:	arch/x86/kernel/io_delay.c
+When:	2.6.28
+Why:	No in tree users
+
+---------------------------
+
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index bd49321..a7b8dfb 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -13,7 +13,7 @@
 #include <asm/io.h>
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
-EXPORT_SYMBOL_GPL(io_delay_type);
+EXPORT_UNUSED_SYMBOL_GPL(io_delay_type);
 
 static int __initdata io_delay_override;
 
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 9cac6c0..66d354f 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -494,7 +494,7 @@ out:
 		return ret;
 	}
 }
-EXPORT_SYMBOL_GPL(__inet_hash_connect);
+EXPORT_UNUSED_SYMBOL_GPL(__inet_hash_connect);
 
 /*
  * Bind a port for a connect operation and hash it.
-- 
1.5.4.1.1278.gc75be



