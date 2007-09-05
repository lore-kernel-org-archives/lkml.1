Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbXIETEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbXIETEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbXIETEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:04:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:46269 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755044AbXIETEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:04:41 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX182p+9Skrk275XD5vFqjUc88I4FqsgYndb0a1LBII
	oeK5rTmtOPfWjR
Message-ID: <46DEFD4C.4030805@gmx.net>
Date: Wed, 05 Sep 2007 21:02:36 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: Ollie Wild <aaw@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: execve manpage changes
References: <65dd6fd50708061738pabd807tb26d38641cc5e7e2@mail.gmail.com> <65dd6fd50708061746p2a460fe5p24f1068c36ef5c40@mail.gmail.com>
In-Reply-To: <65dd6fd50708061746p2a460fe5p24f1068c36ef5c40@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ollie,

Ollie Wild wrote:
> Michael,
> 
> Per our previous discussion, here are the updates to the execve(2)
> manpage resulting from the variable length argument support patch in
> linux-2.6.23-rc1.  The execve API is unmodified.  However, the
> following should be noted in the "Notes" section.
> 
> Prior to linux-2.6.23, the memory used to store the environment and
> argument list strings was limited to 32 (MAX_ARG_PAGES) pages.  On
> most architectures, the page size is 4kB, leading to a maximum size of
> 128kB.
> 
> In linux-2.6.23 and later, most architectures support a size limit
> derived from the current RLIMIT_STACK setting (see getrlimit(2)).  For
> these architectures, the total size is limited to 1/4 the allowed
> stack size, the limit per string is 32 pages (MAX_ARG_STRLEN), and the
> maximum number of strings is 0x7FFFFFFF.  Architectures with no memory
> management unit are excepted: they maintain the pre-2.6.23 limit.

Thanks.  For man-pages-2.66 I have added the following text to execve.2:

   Limits on size of arguments + environment
       Most Unix implementations impose some limit on the total size
       of the command-line argument (argv)  and  environment  (envp)
       strings  that may be passed to a new program.  POSIX.1 allows
       an implementation to advertise this limit using  the  ARG_MAX
       constant  (either  defined  in <limits.h> or available at run
       time using the call sysconf(_SC_ARG_MAX)).

       On Linux prior to kernel 2.6.23, the memory used to store the
       environment  and  argument  strings  was  limited to 32 pages
       (defined by the kernel constant MAX_ARG_PAGES).  On architec-
       tures  with  a  4-kB page size, this yields a maximum size of
       128 kB.

       On kernel 2.6.23 and later, most architectures support a size
       limit  derived from the soft RLIMIT_STACK resource limit (see
       getrlimit(2)).  For these architectures, the  total  size  is
       limited  to  1/4  of  the  allowed  stack size, the limit per
       string is 32 pages (the kernel constant MAX_ARG_STRLEN),  and
       the  maximum  number  of strings is 0x7FFFFFFF.  (This change
       allows programs to have a much larger argument  and/or  envi-
       ronment  list.   Imposing  the 1/4-limit ensures that the new
       program always has some stack space.)  Architectures with  no
       memory  management  unit  are  excepted:  they  maintain  the
       pre-2.6.23 limit.

Cheers,

Michael

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

