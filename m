Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbYKCRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbYKCRYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbYKCRYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:24:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49186 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbYKCRYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:24:10 -0500
Date: Mon, 3 Nov 2008 18:22:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints
Message-ID: <20081103172244.GU31673@kernel.dk>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net> <20081030073134.GM31673@kernel.dk> <20081030110352.GB25056@ghostprotocols.net> <20081030111144.GQ31673@kernel.dk> <20081103172112.GB32603@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081103172112.GB32603@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03 2008, Arnaldo Carvalho de Melo wrote:
> Em Thu, Oct 30, 2008 at 12:11:45PM +0100, Jens Axboe escreveu:
> > On Thu, Oct 30 2008, Arnaldo Carvalho de Melo wrote:
> > > Yes, I tested it, run 'btrace /dev/sda' several times, while doing a
> > > 45 GB backup using rsync over NFS, etc. So it should have exercised the
> > > tracepoints use and repeated registrater/unregister cycles.
> > 
> > Awesome, just wanted to know what level of testing you had done (from
> > "none" to "doesn't crash" to "actually works"), so thanks for that.
> 
> Jens,
> 
> 	Now I'm working on the marker glue code for systemtap to use
> these tracepoints and I noticed that one important piece of information
> is not available unless one first uses blk_trace_ioctl to fill in
> request_queue->blk_trace, that is request_queue->blk_trace->dev, i.e.
> the device associated with the request_queue.
> 
> 	Is there a way to, from the request_queue, get the dev? I guess
> not, as if there would be you wouldn't have added it to struct
> blk_trace...
> 
> 	Would it be sane to add get struct block_device->bd_dev dev_t
> info into struct request_queue at sd_probe time or most probably at some
> more suitable routine in the device/disk registration sequence of
> events?

You can't do that, the queue is nothing more than a transport. There's
no sane way to map from a queue to a device, since it's not given that
there will be a 1:1 mapping even. So no go there, sorry.

> 	I am certainly missing lots of connections here, there are many
> objects and relationships among these objects that may make the
> association of a block_device with a request_queue not to be fixed all
> the time, thus requiring the struct blk_trace ->dev field to be set up
> at ioctl time, but I'm just trying to figure out how to remove the
> requirement of a setup routine for the tracepoints to know what is the
> dev_t associated with the request_queue they are getting as a parameter.
> 
> Best Regards,
> 
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jens Axboe

