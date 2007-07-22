Return-Path: <linux-kernel-owner+w=401wt.eu-S1763946AbXGVLKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763946AbXGVLKD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 07:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXGVLJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 07:09:55 -0400
Received: from ozlabs.org ([203.10.76.45]:43879 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbXGVLJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 07:09:54 -0400
Subject: Re: [PATCH] Remove -static from Documentation/lguest/Makefile
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: caglar@pardus.org.tr, LKML <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <46A0D720.9000204@goop.org>
References: <200707192313.44106.caglar@pardus.org.tr>
	 <1184932973.10380.293.camel@localhost.localdomain>
	 <46A0D720.9000204@goop.org>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 21:09:33 +1000
Message-Id: <1185102573.6344.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 08:39 -0700, Jeremy Fitzhardinge wrote:
> Rusty Russell wrote:
> > How's this?
> > ===
> > Link lguest example launcher non-static
> >
> > S.Caglar Onur points out that many distributions don't ship a static
> > zlib.  Unfortunately the launcher currently maps virtual device memory
> > where shared libraries want to go.
>
> The technique I used in Valgrind was to have a small core program which
> links up high, which then uses mmap to reserve all the client (guest)
> address space, and then dlopens any other libraries, which are
> guaranteed to be loaded high.
> 
> There are a number of subtleties, of course.  You need to make the
> initial stub static, but some versions of glibc have difficulties with
> having static programs use dlopen.  And it means you need to use dlsym
> and do all your library function accesses indirectly, which may not be a
> problem for a relatively simple library like libz.

The other option is to simply mmap the memory and device descriptors,
then tell the kernel the offset.  This means no more linking tricks at
all, but I'd have to check what limit this would impose on maximum guest
physical memory.

And such a significant change is not 2.6.23 material, of course.
Rusty.

