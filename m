Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbZH0JOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbZH0JOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZH0JOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:14:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39056 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZH0JOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:14:53 -0400
Date: Thu, 27 Aug 2009 11:14:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@infradead.org>,
       rostedt@goodmis.org, fweisbec@gmail.com, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: blktrace ftrace plugin, was Re: Receive side performance issue
	with multi-10-GigE and NUMA
Message-ID: <20090827091454.GG12579@kernel.dk>
References: <20090826181502.GC13632@elte.hu> <20090826190435.GC10816@hmsreliant.think-freely.org> <20090826190830.GF13632@elte.hu> <20090826.123631.79533250.davem@davemloft.net> <20090826194835.GA16508@elte.hu> <20090826202344.GE10816@hmsreliant.think-freely.org> <20090826204027.GA21159@elte.hu> <20090827003047.GA30341@infradead.org> <20090827052628.GE12579@kernel.dk> <20090827091227.GB4260@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827091227.GB4260@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27 2009, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Aug 26 2009, Christoph Hellwig wrote:
> > > On Wed, Aug 26, 2009 at 10:40:27PM +0200, Ingo Molnar wrote:
> > > > We are also converting non-trivial plugins to generic tracepoints. A 
> > > > recent example are the system call tracepoints, but we also 
> > > > converted blktrace and kmemtrace to generic tracepoints.
> > > 
> > > On something semi-related: Any reason to keep the blktrace 
> > > ftrace plugin around?  I don't think there's much point in it.  
> > > It only got added in 2.6.29, and all the blktrace tooling just 
> > > uses the legacy ioctls.  All new uses should just use the 
> > > TRACE_EVENT output.
> > 
> > Lets kill it.
> 
> Agreed.
> 
> I think we should keep the relayfs and ioctl compatibility bits 
> though: blktrace has a mature user-space environment with many
> years of installed base.
> 
> We could even move those bits back to block/blktrace_compat.c or so 
> (after the ftrace plugin bits are removed), to make sure it's nicely 
> isolated.
> 
> What do you think?

Of course, we have to retain the ioctl/relayfs interface, it's been in
use for years. Keeping those out of the other trace/ bits sounds sane.

-- 
Jens Axboe

