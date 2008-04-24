Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbYDXMq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbYDXMq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYDXMqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:46:48 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:53134 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDXMqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:46:47 -0400
Date: Thu, 24 Apr 2008 14:47:02 +0200
From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, joe@perches.com
Subject: [patch] Undo some parts of commit e40c0fe that makes too much
 cleanup
Message-ID: <20080424144702.156c6d07@frecb000711.frec.bull.fr>
Organization: Bull S.A.
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

  This patch solves an issue that appears when compiling kvm-userspace
on my x86_64 processor.

  It undo some parts of the commit e40c0fe that cleans duplicate
includes. The commit made too much cleanup ;) because it removed the
"#else" part of the #ifdef __KERNEL__ in include/asm-x86/posix_types.h
and in include/asm-x86/unistd.h

 posix_types.h |    8 +++++++-
 unistd.h      |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)


Signed-off-by: guillaume.thouvenin@ext.bull.net

---

diff --git a/include/asm-x86/posix_types.h b/include/asm-x86/posix_types.h
index fe312a5..bb7133d 100644
--- a/include/asm-x86/posix_types.h
+++ b/include/asm-x86/posix_types.h
@@ -1,5 +1,11 @@
 #ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+# ifdef CONFIG_X86_32
+#  include "posix_types_32.h"
+# else
+#  include "posix_types_64.h"
+# endif
+#else
+# ifdef __i386__
 #  include "posix_types_32.h"
 # else
 #  include "posix_types_64.h"
diff --git a/include/asm-x86/unistd.h b/include/asm-x86/unistd.h
index effc7ad..2a58ed3 100644
--- a/include/asm-x86/unistd.h
+++ b/include/asm-x86/unistd.h
@@ -1,5 +1,11 @@
 #ifdef __KERNEL__
-# if defined(CONFIG_X86_32) || defined(__i386__)
+# ifdef CONFIG_X86_32
+#  include "unistd_32.h"
+# else
+#  include "unistd_64.h"
+# endif
+#else
+# ifdef __i386__
 #  include "unistd_32.h"
 # else
 #  include "unistd_64.h"
