Return-Path: <linux-kernel-owner+w=401wt.eu-S932758AbZHDKjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758AbZHDKjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbZHDKjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:39:16 -0400
Received: from viefep17-int.chello.at ([62.179.121.37]:50948 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbZHDKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:39:15 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] basic perf support for sparc
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Riss <frederic.riss@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Jens Axboe <jens.axboe@oracle.com>,
       Anton Blanchard <anton@samba.org>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       benh@kernel.crashing.org, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com, paulus@samba.org, williams@redhat.com
In-Reply-To: <87d3b2040908040332i87bf211y8fc782d67b3157a3@mail.gmail.com>
References: <20090729192814.GT4148@kernel.dk>
	 <20090801082048.GX12579@kernel.dk>
	 <20090801182216.GA25334@ghostprotocols.net>
	 <20090802184148.GB17241@elte.hu>
	 <20090802194454.GC28572@bombadil.infradead.org>
	 <20090802195043.GD24486@elte.hu>
	 <20090802201132.GE28572@bombadil.infradead.org>
	 <20090802204701.GE25334@ghostprotocols.net>
	 <20090803015430.GG25334@ghostprotocols.net>
	 <20090804092540.GA29778@elte.hu>
	 <87d3b2040908040332i87bf211y8fc782d67b3157a3@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 12:38:52 +0200
Message-Id: <1249382332.7924.192.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-04 at 12:32 +0200, Frederic Riss wrote:
> 2009/8/4 Ingo Molnar <mingo@elte.hu>:
> >
> > * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> >
> >> +static void load_perf_bfd_demangle(void)
> >> +{
> >> +     void *handle = dlopen("libbfd-2.19.51.0.2-17.fc11.so", RTLD_NOW);
> >
> > Hm, this does not look like a very generic solution. Is there some
> > way to do a library search to figure out the name? I guess a glob
> > match on /usr/lib/libbfd*.so?
> 
> If all you want is C++ symbols demangling, why not just look for the
> c++filt binary on the system? It accepts mangled names on its stdin
> and outputs the demangled name on stdout.  You can keep it running in
> the background, and communicate through pipes. Of course it's not as
> effective as a library call, but I guess that it'll be much more
> generic and also much more likely to be found on a developer's system
> than a libbfd shared library.

Oddly enough c++filt uses libbfd :-)

$ ldd `which c++filt`
        linux-gate.so.1 =>  (0xffffe000)
        libbfd-2.19.1.so => /usr/lib/libbfd-2.19.1.so (0xf7de9000)
        libz.so.1 => /lib/libz.so.1 (0xf7dd3000)
        libc.so.6 => /lib/tls/i686/cmov/libc.so.6 (0xf7c6f000)
        /lib/ld-linux.so.2 (0xf7ef9000)


