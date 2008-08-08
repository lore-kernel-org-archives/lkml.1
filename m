Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbYHHFkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbYHHFkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 01:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHHFkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 01:40:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbYHHFkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 01:40:13 -0400
Date: Thu, 7 Aug 2008 22:38:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: prasad@linux.vnet.ibm.com
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
       dwilder@us.ibm.com, hch@infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, mathieu.desnoyers@polymtl.ca,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Patch 0/2] Renaming 'trace' to 'relay' and enhancements to
 'relay'
Message-Id: <20080807223810.7d29a519.akpm@linux-foundation.org>
In-Reply-To: <20080808035239.GB3756@in.ibm.com>
References: <20080804040439.GA6415@in.ibm.com>
	<20080804152532.9367abff.akpm@linux-foundation.org>
	<y0mmyjqji5h.fsf@ton.toronto.redhat.com>
	<20080808035239.GB3756@in.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 09:22:39 +0530 "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:

> On Wed, Aug 06, 2008 at 11:08:10AM -0400, Frank Ch. Eigler wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > 
> > > [...]
> > >> 	Please find the patches that enhance the 'trace' infrastructure
> > >> (available in the -mm tree) and which introduce two new APIs
> > >> relay_dump() and relay_printk().
> > >> [...]
> > 
> > > I'm a bit perplexed by these trace patches
> > > (http://userweb.kernel.org/~akpm/mmotm/broken-out/trace-code [...]
> > > Is it useful?  Will it be useful?  [...]  I haven't heard much noise
> > > about it and I'm struggling to justify merging it.
> > 
> > Right.
> > 
> > > Also, it's starting to look somewhat similar to ftrace, which also
> > > provides sort of high-bandwidth per-cpu channels into userspace for
> > > tracing purposes.
> > 
> > Perhaps ftrace ought to use this facility for its debugfs-facing bulk
> > data interface rather than an internal one that cannot be used by
> > anyone else.  Perhaps lttng could use it.  Systemtap could.  I believe
> > a grand unification at this level was the idea.
> >
> 
> Hi Andrew,
> 	The 'relay_printk' and 'relay_dump' interfaces were meant to
> provide clutter-free tracing interface for the user who does not want to
> care much beyond getting his trace output to user-space. It greatly
> helps reduce the amount of work that a tracer needs to perform to setup
> and tear-down. For e.g. when the Block I/O tracing code in
> block/blktrace.c was converted to use these interfaces they resulted in
> code-reduction of ~130 lines (http://lkml.org/lkml/2008/5/16/318).
> 
> The default values can work fine for most tunables and are also exposed
> to the user for overriding them.
> 
> These interfaces will be helpful in almost all non-blocking tracers
> (unlike usbmon which displays information in real-time) and uses the
> scalable infrastructure provided by 'relay'.
> 
> As pointed out by Frank earlier, most tracers (including ftrace) can be
> made to use the above-mentioned interfaces resulting in substantial
> savings in terms of LoC and increasing modularity/code re-usability.
> 

Oh, OK, that's a good case.

Was the result of your blktrace conversion compatible with existing
interfaces?

It would be higly persuasive if we were to see at least a prototype
conversion of ftrace to use this new code (hint :))



On a naming note: I am officially utterly bewildered by the number of
subsystems which call themselves "trace" or "footrace" or "tracebar". 
And we have at least one more (ltt) (a footracebar!) heading in our
direction.

y:/usr/src/linux-2.6.27-rc2> find -type f -a -name '*trace*' | wc -l
144

(!)

Is there something we can do to bring order out of chaos here?
