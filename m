Return-Path: <linux-kernel-owner+w=401wt.eu-S1765434AbXHDSHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765434AbXHDSHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755967AbXHDSHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:07:24 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33911
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764965AbXHDSHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:07:23 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: akpm@linux-foundation.org
Subject: [PATCH] Documentation/make/headers_install.txt
Date: Sat, 4 Aug 2007 14:07:18 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041307.18578.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Signed-off-by: Rob Landley <rob@landley.net>

Some documentation for "make headers_install".

---

Earlier discussion was at http://lkml.org/lkml/2007/6/22/7 and I
believe I've responded to all of David's comments.

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ linux-2.6/Documentation/make/headers_install.txt	2007-08-04 13:04:51.000000000 -0500
@@ -0,0 +1,46 @@
+Exporting kernel headers for use by userspace
+=============================================
+
+The "make headers_install" command exports the kernel's header files in a
+form suitable for use by userspace programs. 
+
+The linux kernel's exported header files describe the API for user space
+programs attempting to use kernel services.  These kernel header files are
+used by the system's C library (such as glibc or uClibc) to define available
+system calls, as well as constants and structures to be used with these
+system calls.  The C library's header files include the kernel header files
+from the "linux" subdirectory.  The system's libc headers are usually
+installed at the default location /usr/include and the kernel headers in
+subdirectories under that (most notably /usr/include/linux and
+/usr/include/asm).
+
+Kernel headers are backwards compatible, but not forwards compatible.  This
+means that a program built against a C library using older kernel headers
+should run on a newer kernel (although it may not have access to new
+features), but a program built against newer kernel headers may not work on an
+older kernel.
+
+The "make headers_install" command can be run in the top level directory of the
+kernel source code (or using a standard out-of-tree build).  It takes two
+optional arguments:
+
+  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
+
+ARCH indicates which architecture to produce headers for, and defaults to the
+current architecture.  The linux/asm directory of the exported kernel headers
+is platform-specific, to see a complete list of supported architectures use
+the command:
+
+  ls -d include/asm-* | sed 's/.*-//'
+
+INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
+"./usr/include".
+
+The command "make headers_install_all" exports headers for all architectures
+simultaneously.  (This is mostly of interest to distribution maintainers,
+who create an architecture-independent tarball from the resulting include
+directory.)  Remember to provide the appropriate linux/asm directory via "mv"
+or "ln -s" before building a C library with headers exported this way.
+
+The kernel header export infrastructure is maintained by David Woodhouse
+<dwmw2@infradead.org>.


-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
