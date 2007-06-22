Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbXFVEGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbXFVEGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 00:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXFVEEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 00:04:24 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36219
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbXFVEEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 00:04:23 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: [DOCS] make headers_install
Date: Fri, 22 Jun 2007 00:04:26 -0400
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220004.27754.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a really quick stab at documentation for make headers_install.

Comments?

--------------------

Exporting kernel headers for use by userspace (/usr/include/linux)

The "make headers_install" command exports the kernel's header files in a
form suitable for use by userspace programs. 

The linux kernel's exported header files describe the API for user space
programs attempting to use kernel services.  These kernel header files are
used by the system's C library (such as glibc or uClibc) to define available
system calls, as well as constants and structures to be used with these
system calls.  The C library's header files include the kernel header files
from the "linux" subdirectory.  The system's libc headers are usually
installed at the default location /usr/include and the kernel headers at
/usr/include/linux.

Kernel headers are backwards compatible, but not forwards compatible.  This
means that a program built against a C library using older kernel headers
should run on a newer kernel (although it may not have access to new
features), but a program built against newer kernel headers may not work on an
older kernel.

The "make headers_install" command can be run in the top level directory of 
the
kernel source code (or using a standard out-of-tree build).  It takes two
optional arguments:

  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include

ARCH indicates which architecture to produce headers for, and defaults to the
current architecture.  The linux/asm directory of the exported kernel headers
is platform-specific, to see a complete list of supported architectures use
the command:

  ls -d include/asm-* | sed 's/.*-//'

INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
"./usr/include".

The command "make headers_install_all" exports headers for all architectures
simultaneously.  (This is mostly of interest to distribution maintainers,
who create an architecture-independent tarball from the resulting include
directory.)  Remember to provide the appropriate linux/asm directory via "mv"
or "ln -s" before building a C library with headers exported this way.

The kernel header export infrastructure is maintained by David Woodhouse
<dwmw2@infradead.org>.

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
