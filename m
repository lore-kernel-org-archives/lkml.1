Return-Path: <linux-kernel-owner+w=401wt.eu-S1753552AbYKCSJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbYKCSJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKCSIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:08:55 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37253 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYKCSIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:08:54 -0500
Date: Mon, 3 Nov 2008 16:08:45 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints
Message-ID: <20081103180845.GC32603@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net> <20081030073134.GM31673@kernel.dk> <20081030110352.GB25056@ghostprotocols.net> <20081030111144.GQ31673@kernel.dk> <20081103172112.GB32603@ghostprotocols.net> <20081103172244.GU31673@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103172244.GU31673@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 03, 2008 at 06:22:45PM +0100, Jens Axboe escreveu:
> On Mon, Nov 03 2008, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Oct 30, 2008 at 12:11:45PM +0100, Jens Axboe escreveu:
> > > On Thu, Oct 30 2008, Arnaldo Carvalho de Melo wrote:
> > > > Yes, I tested it, run 'btrace /dev/sda' several times, while doing a
> > > > 45 GB backup using rsync over NFS, etc. So it should have exercised the
> > > > tracepoints use and repeated registrater/unregister cycles.
> > > 
> > > Awesome, just wanted to know what level of testing you had done (from
> > > "none" to "doesn't crash" to "actually works"), so thanks for that.
> > 
> > Jens,
> > 
> > 	Now I'm working on the marker glue code for systemtap to use
> > these tracepoints and I noticed that one important piece of information
> > is not available unless one first uses blk_trace_ioctl to fill in
> > request_queue->blk_trace, that is request_queue->blk_trace->dev, i.e.
> > the device associated with the request_queue.
> > 
> > 	Is there a way to, from the request_queue, get the dev? I guess
> > not, as if there would be you wouldn't have added it to struct
> > blk_trace...
> > 
> > 	Would it be sane to add get struct block_device->bd_dev dev_t
> > info into struct request_queue at sd_probe time or most probably at some
> > more suitable routine in the device/disk registration sequence of
> > events?
> 
> You can't do that, the queue is nothing more than a transport. There's
> no sane way to map from a queue to a device, since it's not given that
> there will be a 1:1 mapping even. So no go there, sorry.

No problem, its just that users such as systemtap will need to be
provided a way to ask for the mapping to be established just like
blktrace does today, except that no relay channel will be setup, etc.
Then, at tracepoint time, if the mapping was established, i.e. if
q->blk_trace is non NULL, we will then be able to look at
q->blk_trace->dev.

I'll come up with a patch for comments.

- Arnaldo
