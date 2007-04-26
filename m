Return-Path: <linux-kernel-owner+w=401wt.eu-S1031482AbXDZT7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031482AbXDZT7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 15:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031483AbXDZT7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 15:59:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:36256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031482AbXDZT7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 15:59:08 -0400
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: linux-2.6.21 and __udivid3
Date: Thu, 26 Apr 2007 12:57:06 -0700
Organization: OSDL
Message-ID: <20070426125706.077a3a72@freekitty>
References: <768a59a70704260824s584bb20fs8d4554dcca2d4c27@mail.gmail.com>
	<20070426175526.GR3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Trace: build.pdx.osdl.net 1177617438 22668 10.8.0.230 (26 Apr 2007 19:57:18 GMT)
X-Complaints-To: abuse@osdl.org
NNTP-Posting-Date: Thu, 26 Apr 2007 19:57:18 +0000 (UTC)
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 19:55:26 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> On Fri, Apr 27, 2007 at 12:24:32AM +0900, l l wrote:
> > Hi,
> >
> > How to link libgcc.a with linux-2.6.21?
> >
> >  LD      .tmp_vmlinux1
> > kernel/built-in.o: In function `timespec_add_ns':
> > /usr/src/linux-2.6.21/kernel/timer.c:828: undefined reference to 
> > `__udivdi3'
> > /usr/src/linux-2.6.21/kernel/timer.c:841: undefined reference to 
> > `__udivdi3'
> > /usr/src/linux-2.6.21/kernel/timer.c:1311: undefined reference to 
> > `__udivdi3'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make[1]: Leaving directory `/usr/src/linux-2.6.21'
> > make: *** [debian/stamp-build-kernel] Error 2
> 
> I assume this is a plain 2.6.21 from ftp.kernel.org?
> 
> > cc -v
> > Using built-in specs.
> > Target: i686-pc-linux-gnu
> > Configured with: ../gcc/configure --prefix=/usr --libexecdir=/usr/lib
> > --enable-shared --enable-threads=posix --enable-__cxa_atexit
> > --enable-clocale=gnu --enable-languages=c,c++,treelang
> > --with-system-zlib --with-gmp --enable-mpfr
> > --enable-libstdcxx-allocator=mt
> > Thread model: posix
> > gcc version 4.3.0 20070420 (experimental)
> 
> Can you reproduce this with gcc 4.1?
> If yes, please send your .config .
> 
> > TIA
> 
> cu
> Adrian
> 

I wonder if GCC 4.3 is trying to optimize this loop into a divide/remainder?
If so, then it is time to give the gcc developers a little talking to.


static inline void timespec_add_ns(struct timespec *a, u64 ns)
{
	ns += a->tv_nsec;
	while(unlikely(ns >= NSEC_PER_SEC)) {
		ns -= NSEC_PER_SEC;
		a->tv_sec++;
	}
	a->tv_nsec = ns;
}


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
