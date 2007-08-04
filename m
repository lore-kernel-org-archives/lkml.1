Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXHDSwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXHDSwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 14:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765195AbXHDSwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 14:52:14 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:21964 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765107AbXHDSwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 14:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Wy7hfTFvo6crMPjG3BPMQbnHQjqYTZ5ss86/rGdh3mVO7VCQ14s0w/DOkKfvTqAwH/lnDBU6XwtS/MzcL68p3adMZdvCYJEbhdriPSEACAk9LJQ7usbyngHTt3bHWikzWJYv+enFBIJ4y5uvwFH04ZI5QWVWsUm1g6OgD2mdLS0=
Message-ID: <9a8748490708041152g2ae1b8cag2a42ee6909ce8ee5@mail.gmail.com>
Date: Sat, 4 Aug 2007 20:52:12 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH] Documentation/make/headers_install.txt
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <200708041307.18578.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708041307.18578.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/07, Rob Landley <rob@landley.net> wrote:
> From: Rob Landley <rob@landley.net>
>
> Signed-off-by: Rob Landley <rob@landley.net>
>
> Some documentation for "make headers_install".
>
> ---
>
> Earlier discussion was at http://lkml.org/lkml/2007/6/22/7 and I
> believe I've responded to all of David's comments.
>
> --- /dev/null   2007-04-23 10:59:00.000000000 -0500
> +++ linux-2.6/Documentation/make/headers_install.txt    2007-08-04 13:04:51.000000000 -0500
> @@ -0,0 +1,46 @@
> +Exporting kernel headers for use by userspace
> +=============================================
> +
> +The "make headers_install" command exports the kernel's header files in a
> +form suitable for use by userspace programs.
> +
> +The linux kernel's exported header files describe the API for user space
> +programs attempting to use kernel services.  These kernel header files are
> +used by the system's C library (such as glibc or uClibc) to define available
> +system calls, as well as constants and structures to be used with these
> +system calls.  The C library's header files include the kernel header files
> +from the "linux" subdirectory.  The system's libc headers are usually
> +installed at the default location /usr/include and the kernel headers in
> +subdirectories under that (most notably /usr/include/linux and
> +/usr/include/asm).
> +
> +Kernel headers are backwards compatible, but not forwards compatible.  This

Perhaps change the text "are backwards compatible" into "try very hard
to be backwards compatible" ... ?

> +means that a program built against a C library using older kernel headers
> +should run on a newer kernel (although it may not have access to new
> +features), but a program built against newer kernel headers may not work on an
> +older kernel.
> +
> +The "make headers_install" command can be run in the top level directory of the
> +kernel source code (or using a standard out-of-tree build).  It takes two
> +optional arguments:
> +
> +  make headers_install ARCH=i386 INSTALL_HDR_PATH=/usr/include
> +
> +ARCH indicates which architecture to produce headers for, and defaults to the
> +current architecture.  The linux/asm directory of the exported kernel headers
> +is platform-specific, to see a complete list of supported architectures use
> +the command:

how about s/"the command"/"the following command from inside a kernel
source tree"/ ?

> +
> +  ls -d include/asm-* | sed 's/.*-//'
> +
> +INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
> +"./usr/include".
> +
> +The command "make headers_install_all" exports headers for all architectures
> +simultaneously.  (This is mostly of interest to distribution maintainers,
> +who create an architecture-independent tarball from the resulting include
> +directory.)  Remember to provide the appropriate linux/asm directory via "mv"
> +or "ln -s" before building a C library with headers exported this way.
> +
> +The kernel header export infrastructure is maintained by David Woodhouse
> +<dwmw2@infradead.org>.
>

Overall, looks good.

Acked by: Jesper Juhl <jesper.juhl@gmail.com>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
