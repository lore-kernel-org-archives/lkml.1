Return-Path: <linux-kernel-owner+w=401wt.eu-S1759606AbZFTBNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606AbZFTBNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759006AbZFTBMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:12:52 -0400
Received: from cmpxchg.org ([85.214.51.133]:41532 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758962AbZFTBMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:12:51 -0400
Date: Sat, 20 Jun 2009 03:09:39 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
       LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>
Subject: [patch] ipc: unbreak 32-bit shmctl/semctl/msgctl
Message-ID: <20090620010939.GA3469@cmpxchg.org>
References: <cover.1245345894.git.arnd@arndb.de> <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de> <200906190031.17786.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906190031.17786.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31a985f "ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h" would
choose the implementation of ipc_parse_version() based on a symbol
defined in <asm/unistd.h>.

But it failed to also include this header and thus broke
IPC_64-passing 32-bit userspace because the flag wasn't masked out
properly anymore and the command not understood.

Include <linux/unistd.h> to give the architecture a chance to ask for
the no-no-op ipc_parse_version().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 ipc/util.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/ipc/util.h b/ipc/util.h
index ab3ebf2..764b51a 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -10,6 +10,7 @@
 #ifndef _IPC_UTIL_H
 #define _IPC_UTIL_H
 
+#include <linux/unistd.h>
 #include <linux/err.h>
 
 #define SEQ_MULTIPLIER	(IPCMNI)
-- 
1.6.3.2
