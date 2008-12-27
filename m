Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYL0JhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYL0JhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYL0JhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:37:11 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36397
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYL0JhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:37:10 -0500
Date: Sat, 27 Dec 2008 01:37:12 -0800 (PST)
Message-Id: <20081227.013712.63335017.davem@davemloft.net>
To: sam@ravnborg.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org, mingo@elte.hu,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, kenchen@google.com,
       paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
       linux-next@vger.kernel.org
Subject: Re: [PATCH] sparc64: use unsigned long long for u64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081227092404.GA10375@uranus.ravnborg.org>
References: <20081223131746.GA7456@uranus.ravnborg.org>
	<20081227.005452.261413194.davem@davemloft.net>
	<20081227092404.GA10375@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 27 Dec 2008 10:24:04 +0100

> So it looks like my gcc does not promote:
> ((tagval & 0x0fffffff00000000UL) >> 19UL) to unsigned long long int
> but your gcc does?
> 
> My gcc (build with Dan Kegel's crosstool):
> $ /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/bin/sparc64-unknown-linux-gnu-gcc -v
> Reading specs from /opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/lib/gcc/sparc64-unknown-linux-gnu/3.4.5/specs
> Configured with: /home/sam/devel/crosstool-0.43/build/sparc64-unknown-linux-gnu/gcc-3.4.5-glibc-2.3.6/gcc-3.4.5/configure --target=sparc64-unknown-linux-gnu --host=i686-host_pc-linux-gnu --prefix=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu --disable-multilib --with-cpu=ultrasparc3 --enable-cxx-flags=-mcpu=ultrasparc3 --with-headers=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/sparc64-unknown-linux-gnu/include --with-local-prefix=/opt/crosstool/gcc-3.4.5-glibc-2.3.6/sparc64-unknown-linux-gnu/sparc64-unknown-linux-gnu --disable-nls --enable-threads=posix --enable-symvers=gnu --enable-__cxa_atexit --enable-languages=c --enable-shared --enable-c99 --enable-long-long
> Thread model: posix
> gcc version 3.4.5

I'm using a native gcc-4.1.3 here:

gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)

When you cross build 32-bit to 64-bit, a small but non-zero
number of warning checks and optimizations are not performed
and I think that is what you're hitting here.
