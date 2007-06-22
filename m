Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXFVUSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXFVUSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbXFVUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:18:48 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43574
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXFVUSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:18:47 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [DOCS] make headers_install
Date: Fri, 22 Jun 2007 16:18:58 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200706220004.27754.rob@landley.net> <1182489291.10524.43.camel@shinybook.infradead.org>
In-Reply-To: <1182489291.10524.43.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_y6CfGZt5z5zW54S"
Message-Id: <200706221618.58455.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_y6CfGZt5z5zW54S
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 22 June 2007 01:14:50 David Woodhouse wrote:
> On Fri, 2007-06-22 at 00:04 -0400, Rob Landley wrote:
> > Here's a really quick stab at documentation for make headers_install.
> >
> > Comments?
> >
> > --------------------
> >
> > Exporting kernel headers for use by userspace (/usr/include/linux)
>
> Also /usr/include/asm (and asm-* on biarch 64-bit architectures), along
> with a few other directories. See $linux/include/Kbuild.
>
> Other than that it looks relatively sane; thanks.

For some reason I was thinking that the asm directory was under include/linux 
even though I know that's not the case.  Brain glitch.

This clear things up?

--- headers.bak 2007-06-22 16:13:42.000000000 -0400
+++ headers.txt 2007-06-22 16:16:22.000000000 -0400
@@ -9,8 +9,9 @@
 system calls, as well as constants and structures to be used with these
 system calls.  The C library's header files include the kernel header files
 from the "linux" subdirectory.  The system's libc headers are usually
-installed at the default location /usr/include and the kernel headers at
-/usr/include/linux.
+installed at the default location /usr/include and the kernel headers in
+subdirectories under that (most notably /usr/include/linux and
+/usr/include/asm).

 Kernel headers are backwards compatible, but not forwards compatible.  This
 means that a program built against a C library using older kernel headers

New version attached.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_y6CfGZt5z5zW54S
Content-Type: text/plain;
  charset="utf-8";
  name="headers_install.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="headers_install.txt"

Exporting kernel headers for use by userspace (/usr/include/linux)

The "make headers_install" command exports the kernel's header files in a
form suitable for use by userspace programs. 

The linux kernel's exported header files describe the API for user space
programs attempting to use kernel services.  These kernel header files are
used by the system's C library (such as glibc or uClibc) to define available
system calls, as well as constants and structures to be used with these
system calls.  The C library's header files include the kernel header files
from the "linux" subdirectory.  The system's libc headers are usually
installed at the default location /usr/include and the kernel headers in
subdirectories under that (most notably /usr/include/linux and
/usr/include/asm).

Kernel headers are backwards compatible, but not forwards compatible.  This
means that a program built against a C library using older kernel headers
should run on a newer kernel (although it may not have access to new
features), but a program built against newer kernel headers may not work on an
older kernel.

The "make headers_install" command can be run in the top level directory of the
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

--Boundary-00=_y6CfGZt5z5zW54S--
