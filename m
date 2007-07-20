Return-Path: <linux-kernel-owner+w=401wt.eu-S937522AbXGTPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937522AbXGTPk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 11:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932646AbXGTPkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 11:40:20 -0400
Received: from gw.goop.org ([64.81.55.164]:56004 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647AbXGTPkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 11:40:18 -0400
Message-ID: <46A0D720.9000204@goop.org>
Date: Fri, 20 Jul 2007 08:39:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: caglar@pardus.org.tr, LKML <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] Remove -static from Documentation/lguest/Makefile
References: <200707192313.44106.caglar@pardus.org.tr> <1184932973.10380.293.camel@localhost.localdomain>
In-Reply-To: <1184932973.10380.293.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-9
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> How's this?
> ===
> Link lguest example launcher non-static
>
> S.Caglar Onur points out that many distributions don't ship a static
> zlib.  Unfortunately the launcher currently maps virtual device memory
> where shared libraries want to go.
>
> The solution is to pre-scan the args to figure out how much memory we
> have, then allocate devices above that, rather than down from the top.
>   

The technique I used in Valgrind was to have a small core program which
links up high, which then uses mmap to reserve all the client (guest)
address space, and then dlopens any other libraries, which are
guaranteed to be loaded high.

There are a number of subtleties, of course.  You need to make the
initial stub static, but some versions of glibc have difficulties with
having static programs use dlopen.  And it means you need to use dlsym
and do all your library function accesses indirectly, which may not be a
problem for a relatively simple library like libz.

    J
