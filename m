Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbZH0JMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbZH0JMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZH0JMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:12:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50967 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZH0JMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:12:44 -0400
Date: Thu, 27 Aug 2009 11:12:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Christoph Hellwig <hch@infradead.org>, rostedt@goodmis.org,
       fweisbec@gmail.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: blktrace ftrace plugin, was Re: Receive side performance issue
	with multi-10-GigE and NUMA
Message-ID: <20090827091227.GB4260@elte.hu>
References: <20090826181502.GC13632@elte.hu> <20090826190435.GC10816@hmsreliant.think-freely.org> <20090826190830.GF13632@elte.hu> <20090826.123631.79533250.davem@davemloft.net> <20090826194835.GA16508@elte.hu> <20090826202344.GE10816@hmsreliant.think-freely.org> <20090826204027.GA21159@elte.hu> <20090827003047.GA30341@infradead.org> <20090827052628.GE12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827052628.GE12579@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Aug 26 2009, Christoph Hellwig wrote:
> > On Wed, Aug 26, 2009 at 10:40:27PM +0200, Ingo Molnar wrote:
> > > We are also converting non-trivial plugins to generic tracepoints. A 
> > > recent example are the system call tracepoints, but we also 
> > > converted blktrace and kmemtrace to generic tracepoints.
> > 
> > On something semi-related: Any reason to keep the blktrace 
> > ftrace plugin around?  I don't think there's much point in it.  
> > It only got added in 2.6.29, and all the blktrace tooling just 
> > uses the legacy ioctls.  All new uses should just use the 
> > TRACE_EVENT output.
> 
> Lets kill it.

Agreed.

I think we should keep the relayfs and ioctl compatibility bits 
though: blktrace has a mature user-space environment with many
years of installed base.

We could even move those bits back to block/blktrace_compat.c or so 
(after the ftrace plugin bits are removed), to make sure it's nicely 
isolated.

What do you think?

	Ingo
