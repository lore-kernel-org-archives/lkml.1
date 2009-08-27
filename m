Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZH0Nza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZH0Nza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZH0Nz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:55:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZH0Nz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:55:29 -0400
Date: Thu, 27 Aug 2009 10:55:07 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Christoph Hellwig <hch@infradead.org>, rostedt@goodmis.org,
       fweisbec@gmail.com, acme@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: blktrace ftrace plugin, was Re: Receive side performance issue
	with multi-10-GigE and NUMA
Message-ID: <20090827135507.GL5255@ghostprotocols.net>
References: <20090826190435.GC10816@hmsreliant.think-freely.org> <20090826190830.GF13632@elte.hu> <20090826.123631.79533250.davem@davemloft.net> <20090826194835.GA16508@elte.hu> <20090826202344.GE10816@hmsreliant.think-freely.org> <20090826204027.GA21159@elte.hu> <20090827003047.GA30341@infradead.org> <20090827052628.GE12579@kernel.dk> <20090827091227.GB4260@elte.hu> <20090827091454.GG12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827091454.GG12579@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 27, 2009 at 11:14:54AM +0200, Jens Axboe escreveu:
> On Thu, Aug 27 2009, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Wed, Aug 26 2009, Christoph Hellwig wrote:
> > > > On Wed, Aug 26, 2009 at 10:40:27PM +0200, Ingo Molnar wrote:
> > > > > We are also converting non-trivial plugins to generic tracepoints. A 
> > > > > recent example are the system call tracepoints, but we also 
> > > > > converted blktrace and kmemtrace to generic tracepoints.
> > > > 
> > > > On something semi-related: Any reason to keep the blktrace 
> > > > ftrace plugin around?  I don't think there's much point in it.  
> > > > It only got added in 2.6.29, and all the blktrace tooling just 
> > > > uses the legacy ioctls.  All new uses should just use the 
> > > > TRACE_EVENT output.
> > > 
> > > Lets kill it.
> > 
> > Agreed.
> > 
> > I think we should keep the relayfs and ioctl compatibility bits 
> > though: blktrace has a mature user-space environment with many
> > years of installed base.
> > 
> > We could even move those bits back to block/blktrace_compat.c or so 
> > (after the ftrace plugin bits are removed), to make sure it's nicely 
> > isolated.
> > 
> > What do you think?
> 
> Of course, we have to retain the ioctl/relayfs interface, it's been in
> use for years. Keeping those out of the other trace/ bits sounds sane.

Yeah, I wonder tho if we couldn't somehow use the ring buffer
infrastructure in such a way as to provide the debugfs visible interface
provided by relayfs, IIRC systemtap is doing such a move too.

- Arnaldo
