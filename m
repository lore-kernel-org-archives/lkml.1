Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXC3XIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXC3XIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXC3XIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:08:53 -0400
Received: from mbox.ssc.unict.it ([151.97.230.9]:52868 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbXC3XIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:08:52 -0400
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 2/3] sys_futex64-allows-64bit-futexes-workaround for uml
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pierre Peiffer <pierre.peiffer@bull.net>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Date: Sat, 31 Mar 2007 01:08:09 +0200
Message-ID: <20070330230809.19809.60375.stgit@americanbeauty.home.lan>
In-Reply-To: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
References: <20070330230746.19809.2000.stgit@americanbeauty.home.lan>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Copy sys_futex64-allows-64bit-futexes-workaround.patch to UML (to unbreak the
UML build). Note however that in include/asm-generic/futex.h we have:

static inline int
futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
{
	return -ENOSYS;
}

Which is a better solution. Pierre Peiffer, please consider that.

Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 include/asm-um/futex.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/asm-um/futex.h b/include/asm-um/futex.h
index 6a332a9..e875d3e 100644
--- a/include/asm-um/futex.h
+++ b/include/asm-um/futex.h
@@ -3,4 +3,17 @@
 
 #include <asm-generic/futex.h>
 
+static inline u64
+futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
+{
+	return 0;
+}
+
+static inline int
+futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
+{
+	return 0;
+}
+
+
 #endif



