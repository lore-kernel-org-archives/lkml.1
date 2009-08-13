Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZHMLeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZHMLeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZHMLeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:34:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:45969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbZHMLeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:34:09 -0400
Subject: Re: [PROBLEM] perf report is broken in latest linus git
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <1250156837.8141.4.camel@penberg-laptop>
References: <1250155708.6052.2.camel@penberg-laptop>
	 <20090813093648.GA22762@elte.hu>  <1250156837.8141.4.camel@penberg-laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 13 Aug 2009 13:33:32 +0200
Message-Id: <1250163212.5241.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-13 at 12:47 +0300, Pekka Enberg wrote:
> Hi Ingo,
> 
> On Thu, 2009-08-13 at 11:36 +0200, Ingo Molnar wrote:
> > * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > 
> > > Latest Linus git kernel with -rc4 perf userspace:
> > > 
> > >   penberg@penberg-laptop:~/testing/jato$ perf record -f jato HelloWorldSwing
> > >   [ perf record: Captured and wrote 1.402 MB perf.data (~61261 samples) ]
> > > 
> > >   penberg@penberg-laptop:~/testing/jato$ perf report --sort comm,dso,symbol|head -30
> > >   # Samples: 60457
> > >   #
> > >   # Overhead  Command                            Shared Object  Symbol
> > >   # ........  .......  .......................................  ......
> > >   #
> > > 
> > >   [ Note: the jato executable doesn't appear anywhere in the trace. I'm
> > >     pretty sure the libzip functions, for example, are from jato, not perf.  ]
> > > 
> > >       36.14%     perf  /home/penberg/bin/perf                   [.] dso__synthesize_plt_symbols
> > >       35.20%     perf  /home/penberg/bin/perf                   [.] dso__new
> > >        3.57%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910
> > 
> > Perhaps it's this commit:
> > 
> > 4d1e00a: perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink
> > 
> > it does not revert cleanly, so you might want to check out these two 
> > commits:
> > 
> >   4d1e00a
> >   4d1e00a~1
> > 
> > and build perf on both, and check with your anomalous perf.data 
> > (without changing it) whether the output makes most sense.
> 
> The commit seems fine. Like I said, the perf.data file is busted even
> with 2.6.31-rc4 userspace so I think it's a kernel bug.

Hrmm, does a -tip kernel work as expected? I'll go audit the kernel
changes between -rc4 and -rc5.
