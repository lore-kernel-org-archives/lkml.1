Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXERKrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXERKrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 06:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXERKrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 06:47:13 -0400
Received: from barclay.balt.net ([195.14.162.78]:48397 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754685AbXERKrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 06:47:12 -0400
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux
	2.6.22-rc1 + CFS v12)
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070517184556.GA81@tv-sign.ru>
References: <1179338441.4265.13.camel@zv.wilibox.com>
	 <20070516121538.7b108c10.akpm@linux-foundation.org>
	 <20070516225543.GA337@tv-sign.ru> <1179390065.4760.5.camel@zv.wilibox.com>
	 <20070517184556.GA81@tv-sign.ru>
Content-Type: text/plain
Date: Fri, 18 May 2007 13:47:10 +0300
Message-Id: <1179485230.3800.20.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Thu, 2007-05-17 at 22:45 +0400, Oleg Nesterov wrote:
> Hello Zilvinas,
> 
> On 05/17, Zilvinas Valinskas wrote:
> > 
> > Patch seems to help and it seems kernel doesn't free anymore. I've
> > booted new kernel and did :
> 
> OK, thank you very much. So, we have some other problems, and I _think_
> that workqueue.c is not the source of them.

You are welcome. I wish I could determine and fix the problem myself. I
will try to help, debug the problem as long as there is any progress or
ideas to try out.

> However, I can't understand why cleanup_workqueue_thread() hangs anyway.
> It shouldn't. Looks like rpciod/1 was preempted, and can't get CPU. According
> to kernel-nfs-freeze.log it is TASK_RUNNING. Strange.
> 
> It is very sad, because this code was supposed to be cleanuped anyway,
> but if it is really buggy, it would be great to know why.

Can this be related to :

CONFIG_PREEMPT=y
# CONFIG_PREEMPT_BKL is not set


> Perhaps, we can understand the problem with your help. Could you please
> revert the patch I sent, and send me (privately) the output of
> 
> 	objdump -d kernel/workqueue.o


I have uploaded files at http://barclay.balt.net/~zilvinas/oops/ 

workqueue.objdump - without any patch.
workqueue+oleg-old.objdump - with older patch Oleg sent on Thu, 17 May.
workqueue+oleg-new.objdump - with the newest patch from Oleg applied.

For what it's worth, I am using Debian/Unstable 
$ gcc -v
Using built-in specs.
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --enable-languages=c,c
++,fortran,objc,obj-c++,treelang --prefix=/usr --enable-shared
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --enable-nls
--with-gxx-include-dir=/usr/include/c++/4.1.3 --program-suffix=-4.1
--enable-__cxa_atexit --enable-clocale=gnu --enable-libstdcxx-debug
--enable-mpfr --enable-checking=release x86_64-linux-gnu
Thread model: posix
gcc version 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)

$ ld -V
GNU ld (GNU Binutils for Debian) 2.17.50.20070426
  Supported emulations:
   elf_x86_64
   elf_i386
   i386linux

> ? I doubt very much I'll see something interesting, but who knows...
> 
> Thanks!
> 
> Oleg.
> 

