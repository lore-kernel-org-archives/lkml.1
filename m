Return-Path: <linux-kernel-owner+w=401wt.eu-S1753362AbZHBSmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbZHBSmG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZHBSmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:42:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbZHBSmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:42:05 -0400
Date: Sun, 2 Aug 2009 20:41:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802184148.GB17241@elte.hu>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090801182216.GA25334@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Sat, Aug 01, 2009 at 10:20:48AM +0200, Jens Axboe escreveu:
> > On Sat, Aug 01 2009, Anton Blanchard wrote:
> > > 
> > > Hi,
> > > 
> > > > > Building the perf tool is somewhat involved on sparc64
> > > > > though, since 64-bit versions of zlib/libelf/bfd aren't
> > > > > directly available (at least on debian 5.x). But once you
> > > > > get there, it runs :-). Would it be easier/functional
> > > > > to build 32-bit userland perf instead?
> > > > 
> > > > Same is true on ppc64, btw. How are others handling this?
> > > 
> > > The requirement for libz was removed, so up until recently we only needed
> > > a 64bit version of elfutils which is easy to build.
> > > 
> > > It looks like we now have a requirement on binutils which is considerably
> > > more painful to build. One option is to make the bfd requirement optional, all
> > > you lose would be the ability to see c++ demangled names I think.
> > 
> > Right, binutils is the ugly one. I got a libbfd.so built for 
> > both ppc and sparc, but it wasn't just a make && make install 
> > job. Personally I could not care less about losing c++ demangled 
> > name support, so that approach sounds fine to me :-)
> 
> Exactly, for a huge number of developers not being able to see 
> demangled C++ is okay, so I agree on adding smarts to not demangle 
> when binutils-devel is not available.
> 
> I thought about extracting the demangling bits out of binutils, 
> ran away screaming. I also hoped elfutils would have that by now, 
> but it doesn't.

Could we somehow define a weak symbol for those library functions 
ourselves and thus just fall back to that (which does nothing) 
instead of failing the link?

	Ingo
