Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYJ3Hcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYJ3Hcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYJ3Hcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:32:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56935 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYJ3Hcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:32:45 -0400
Date: Thu, 30 Oct 2008 08:31:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints
Message-ID: <20081030073134.GM31673@kernel.dk>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029194323.GA25056@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29 2008, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 29, 2008 at 02:18:55PM +0100, Jens Axboe escreveu:
> > > 	Feel free to point any disgusting aspect, perhaps there is at
> > > least one to warn me about fixing 8-)
> > 
> > You my as well pass the members separately now that it's a specific call
> > anyway, to avoid doing the calculation when tracing is disabled.
> > 
> > Patch looks straight forward. Perhaps it would be cleaner to use an
> > atomic type for the reference?
> 
> Done and made the old pdu_int + NULL bio (trace_block_unplug_{io,timer})
> functions to receive just the request_queue.
> 
> Found and fixed a bug in the process:
> 
> In v2 we had:
> 
> +       unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
> +       unregister_trace_block_rq_insert(blk_add_trace_rq_abort);
> 
> Where it should have been:
> 
> +       unregister_trace_block_rq_insert(blk_add_trace_rq_insert);
> +       unregister_trace_block_rq_abort(blk_add_trace_rq_abort);
> 
> c'n'p roblem!
> 
> Also removed the leftover tracepoint_synchronize_unregister macro, it
> was already merged righfully as an inline function.
> 
> Everything should be rock solid now 8)

I'll apply this for 2.6.29. I'm assuming you have tested this as well?

-- 
Jens Axboe

