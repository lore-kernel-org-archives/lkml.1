Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYHHDw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYHHDw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYHHDwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:52:50 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:46765 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbYHHDwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:52:49 -0400
Date: Fri, 8 Aug 2008 09:22:39 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dwilder@us.ibm.com, hch@infradead.org,
       Steven Rostedt <rostedt@goodmis.org>, mathieu.desnoyers@polymtl.ca
Subject: Re: [Patch 0/2] Renaming 'trace' to 'relay' and enhancements to
	'relay'
Message-ID: <20080808035239.GB3756@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080804040439.GA6415@in.ibm.com> <20080804152532.9367abff.akpm@linux-foundation.org> <y0mmyjqji5h.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mmyjqji5h.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 11:08:10AM -0400, Frank Ch. Eigler wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > [...]
> >> 	Please find the patches that enhance the 'trace' infrastructure
> >> (available in the -mm tree) and which introduce two new APIs
> >> relay_dump() and relay_printk().
> >> [...]
> 
> > I'm a bit perplexed by these trace patches
> > (http://userweb.kernel.org/~akpm/mmotm/broken-out/trace-code [...]
> > Is it useful?  Will it be useful?  [...]  I haven't heard much noise
> > about it and I'm struggling to justify merging it.
> 
> Right.
> 
> > Also, it's starting to look somewhat similar to ftrace, which also
> > provides sort of high-bandwidth per-cpu channels into userspace for
> > tracing purposes.
> 
> Perhaps ftrace ought to use this facility for its debugfs-facing bulk
> data interface rather than an internal one that cannot be used by
> anyone else.  Perhaps lttng could use it.  Systemtap could.  I believe
> a grand unification at this level was the idea.
>

Hi Andrew,
	The 'relay_printk' and 'relay_dump' interfaces were meant to
provide clutter-free tracing interface for the user who does not want to
care much beyond getting his trace output to user-space. It greatly
helps reduce the amount of work that a tracer needs to perform to setup
and tear-down. For e.g. when the Block I/O tracing code in
block/blktrace.c was converted to use these interfaces they resulted in
code-reduction of ~130 lines (http://lkml.org/lkml/2008/5/16/318).

The default values can work fine for most tunables and are also exposed
to the user for overriding them.

These interfaces will be helpful in almost all non-blocking tracers
(unlike usbmon which displays information in real-time) and uses the
scalable infrastructure provided by 'relay'.

As pointed out by Frank earlier, most tracers (including ftrace) can be
made to use the above-mentioned interfaces resulting in substantial
savings in terms of LoC and increasing modularity/code re-usability.

Thanks,
K.Prasad

