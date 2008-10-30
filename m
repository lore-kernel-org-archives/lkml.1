Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYJ3LEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYJ3LEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYJ3LEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:04:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33021 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbYJ3LEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:04:09 -0400
Date: Thu, 30 Oct 2008 09:03:52 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints
Message-ID: <20081030110352.GB25056@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net> <20081030073134.GM31673@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030073134.GM31673@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 30, 2008 at 08:31:34AM +0100, Jens Axboe escreveu:
> On Wed, Oct 29 2008, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Oct 29, 2008 at 02:18:55PM +0100, Jens Axboe escreveu:
> > > > 	Feel free to point any disgusting aspect, perhaps there is at
> > > > least one to warn me about fixing 8-)
> > > 
> > > You my as well pass the members separately now that it's a specific call
> > > anyway, to avoid doing the calculation when tracing is disabled.
> > > 
> > > Patch looks straight forward. Perhaps it would be cleaner to use an
> > > atomic type for the reference?
> > 
> > Done and made the old pdu_int + NULL bio (trace_block_unplug_{io,timer})
> > functions to receive just the request_queue.
> > 
> > Found and fixed a bug in the process:
> > 
> > In v2 we had:
> > 
> > +       unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
> > +       unregister_trace_block_rq_insert(blk_add_trace_rq_abort);
> > 
> > Where it should have been:
> > 
> > +       unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
> > +       unregister_trace_block_rq_abort(blk_add_trace_rq_abort);
> > 
> > c'n'p roblem!
> > 
> > Also removed the leftover tracepoint_synchronize_unregister macro, it
> > was already merged righfully as an inline function.
> > 
> > Everything should be rock solid now 8)
> 
> I'll apply this for 2.6.29. I'm assuming you have tested this as well?

Yes, I tested it, run 'btrace /dev/sda' several times, while doing a
45 GB backup using rsync over NFS, etc. So it should have exercised the
tracepoints use and repeated registrater/unregister cycles.

Thanks!

- Arnaldo
