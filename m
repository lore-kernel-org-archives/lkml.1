Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbZHAS1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbZHAS1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 14:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZHAS1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 14:27:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33078 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZHAS1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 14:27:40 -0400
Date: Sat, 1 Aug 2009 15:22:16 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, Ingo Molnar <mingo@elte.hu>,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com,
       acme@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090801182216.GA25334@ghostprotocols.net>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801082048.GX12579@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Aug 01, 2009 at 10:20:48AM +0200, Jens Axboe escreveu:
> On Sat, Aug 01 2009, Anton Blanchard wrote:
> > 
> > Hi,
> > 
> > > > Building the perf tool is somewhat involved on sparc64
> > > > though, since 64-bit versions of zlib/libelf/bfd aren't
> > > > directly available (at least on debian 5.x). But once you
> > > > get there, it runs :-). Would it be easier/functional
> > > > to build 32-bit userland perf instead?
> > > 
> > > Same is true on ppc64, btw. How are others handling this?
> > 
> > The requirement for libz was removed, so up until recently we only needed
> > a 64bit version of elfutils which is easy to build.
> > 
> > It looks like we now have a requirement on binutils which is considerably
> > more painful to build. One option is to make the bfd requirement optional, all
> > you lose would be the ability to see c++ demangled names I think.
> 
> Right, binutils is the ugly one. I got a libbfd.so built for both ppc
> and sparc, but it wasn't just a make && make install job. Personally I
> could not care less about losing c++ demangled name support, so that
> approach sounds fine to me :-)

Exactly, for a huge number of developers not being able to see demangled
C++ is okay, so I agree on adding smarts to not demangle when
binutils-devel is not available.

I thought about extracting the demangling bits out of binutils, ran away
screaming. I also hoped elfutils would have that by now, but it doesn't.

- Arnaldo
