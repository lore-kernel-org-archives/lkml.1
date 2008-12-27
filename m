Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYL0Jsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYL0Jsi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbYL0Js0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:48:26 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:59384 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbYL0JsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:48:25 -0500
Date: Sat, 27 Dec 2008 10:49:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
Message-ID: <20081227094955.GA1355@uranus.ravnborg.org>
References: <20081223131746.GA7456@uranus.ravnborg.org> <20081227.005452.261413194.davem@davemloft.net> <20081227092404.GA10375@uranus.ravnborg.org> <20081227.013712.63335017.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227.013712.63335017.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 01:37:12AM -0800, David Miller wrote:
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 27 Dec 2008 10:24:04 +0100
> 
> > So it looks like my gcc does not promote:
> > ((tagval & 0x0fffffff00000000UL) >> 19UL) to unsigned long long int
> > but your gcc does?
> > 
> > My gcc (build with Dan Kegel's crosstool):
> > $ /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -v
> > Reading specs from /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/lib/gcc/sparc64-unknown-linux-gnu/3.4.5/specs
> > Configured with: /home/sam/devel/crosstool-0.43/build/sparc64-unknown-linux-gnu/gcc-3.4.5-glibc-2.3.6/gcc-3.4.5/configure --target=sparc64-unknown-linux-gnu --host=i686-host_pc-linux-gnu --prefix=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu --disable-multilib --with-cpu=ultrasparc3 --enable-cxx-flags=-mcpu=ultrasparc3 --with-headers=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/sparc64-unknown-linux-gnu/include --with-local-prefix=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/sparc64-unknown-linux-gnu --disable-nls --enable-threads=posix --enable-symvers=gnu --enable-__cxa_atexit --enable-languages=c --enable-shared --enable-c99 --enable-long-long
> > Thread model: posix
> > gcc version 3.4.5
> 
> I'm using a native gcc-4.1.3 here:
> 
> gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
> 
> When you cross build 32-bit to 64-bit, a small but non-zero
> number of warning checks and optimizations are not performed
> and I think that is what you're hitting here.

OK.
I have ordered a used Sun Blade 100(*) that should show up
before new eve.
So when I have it and it is up and running I will redo this
patch set. That will likely take a few weeks though.

(*) Any distribution recommendations? I will only use it for
    sparc kernel development so nothing fancy...

	Sam
