Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbXISNmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbXISNmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 09:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbXISNmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 09:42:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42250 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXISNma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 09:42:30 -0400
Date: Wed, 19 Sep 2007 19:15:00 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Josh Boyer <jwboyer@jdub.homelinux.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linuxppc-dev@ozlabs.org,
       Linux@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from
 panic codepath
In-Reply-To: <20070917204625.64b97392@vader.jdub.homelinux.org>
Message-ID: <alpine.LFD.0.999.0709191844360.7697@enigma.security.iitk.ac.in>
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
 <a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
 <alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
 <20070917183749.fd690505.randy.dunlap@oracle.com>
 <20070917204625.64b97392@vader.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> On Mon, 17 Sep 2007 18:37:49 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > On Tue, 18 Sep 2007 05:13:40 +0530 (IST) Satyam Sharma wrote:
> > 
> > > Untested (not even compile-tested) patch.
> > > Could someone point me to ppc32/64 cross-compilers for i386?
> > 
> > OSDL had some, but those are gone now.
> > I downloaded all of them and still use them, although it would
> > be good to have some more recent versions of them.
> > 
> > I put the power* compiler tarballs here:
> > 
> > http://userweb.kernel.org/~rdunlap/cross-compilers/

Thanks -- BTW I made some simple changes to the tree structure in there
and added a few distcc [*] related scriptlets. The resulting tar ball:

http://www.cse.iitk.ac.in/users/ssatyam/powerpc64-unknown-linux-gnu.tar.bz2

can be made to work with Andrew's nice "xb" script with the following
trivial patch:


--- cross-compilers/read-me.txt~powerpc64	2007-09-19 14:39:01.000000000 +0530
+++ cross-compilers/read-me.txt	2007-09-19 14:44:29.000000000 +0530
@@ -3,7 +3,7 @@ i386 cross-compilation binaries for seve
 on RH FC5 and RH FC6 i386 and x86_64.
 
 - untar the tarball in /
-- setenv ARCH sparc64 (or alpha, arm, i386, ia64, m68k, mips, s390, sparc)
+- setenv ARCH sparc64 (or alpha, arm, i386, ia64, m68k, mips, powerpc64, s390, sh4, sparc, x86_64)
 - xb mrproper
 - xb allmodconfig
 - xb
--- cross-compilers/xb~powerpc64	2007-09-19 14:40:09.000000000 +0530
+++ cross-compilers/xb	2007-09-19 14:52:46.000000000 +0530
@@ -31,6 +31,7 @@ I=vmlinux
 [ $ARCH = m68k ] &&	CT=gcc-4.1.0-glibc-2.3.6
 [ $ARCH = mips ] &&	CT=gcc-3.4.5-glibc-2.3.6
 [ $ARCH = powerpc ] &&	CT=gcc-4.1.0-glibc-2.3.6 && XARCH=powerpc-405-linux-gnu
+[ $ARCH = powerpc64 ] &&	CT=gcc-3.4.0-glibc-2.3.2 && export ARCH=powerpc
 [ $ARCH = s390 ] &&	CT=gcc-4.1.0-glibc-2.3.6
 [ $ARCH = sh ] &&	CT=gcc-3.4.5-glibc-2.3.6 && XARCH=sh4-unknown-linux-gnu
 [ $ARCH = sparc ] &&	CT=gcc-4.1.0-glibc-2.3.6


On Mon, 17 Sep 2007, Josh Boyer wrote:
> 
> Crosstool is widely used.  It'll build several combinations of
> gcc/binutils/glibc for you.  
> 
> http://www.kegel.com/crosstool/

In fact, it turns out OSDL's cross-compiler toolchains were built with
crosstool itself. Should also add that those OSDL compilers are too old
(gcc version 3.4.x-3.5.x mostly -- my build was totally spammed with those
"+m" in asm constraints related warnings), so I'll try and build a few
more recent ones (at least for the more popular platforms) over the
weekend too.


Satyam


[*] But I'm a bit skeptical if the distcc stuff in "xb" works as intended.
    Has anybody used that successfully? Will test it over the weekend ...
