Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbYKCRVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbYKCRVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYKCRVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:21:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60844 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYKCRVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:21:22 -0500
Date: Mon, 3 Nov 2008 15:21:12 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v3] blktrace: conversion to tracepoints
Message-ID: <20081103172112.GB32603@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk> <20081029194323.GA25056@ghostprotocols.net> <20081030073134.GM31673@kernel.dk> <20081030110352.GB25056@ghostprotocols.net> <20081030111144.GQ31673@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030111144.GQ31673@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 30, 2008 at 12:11:45PM +0100, Jens Axboe escreveu:
> On Thu, Oct 30 2008, Arnaldo Carvalho de Melo wrote:
> > Yes, I tested it, run 'btrace /dev/sda' several times, while doing a
> > 45 GB backup using rsync over NFS, etc. So it should have exercised the
> > tracepoints use and repeated registrater/unregister cycles.
> 
> Awesome, just wanted to know what level of testing you had done (from
> "none" to "doesn't crash" to "actually works"), so thanks for that.

Jens,

	Now I'm working on the marker glue code for systemtap to use
these tracepoints and I noticed that one important piece of information
is not available unless one first uses blk_trace_ioctl to fill in
request_queue->blk_trace, that is request_queue->blk_trace->dev, i.e.
the device associated with the request_queue.

	Is there a way to, from the request_queue, get the dev? I guess
not, as if there would be you wouldn't have added it to struct
blk_trace...

	Would it be sane to add get struct block_device->bd_dev dev_t
info into struct request_queue at sd_probe time or most probably at some
more suitable routine in the device/disk registration sequence of
events?

	I am certainly missing lots of connections here, there are many
objects and relationships among these objects that may make the
association of a block_device with a request_queue not to be fixed all
the time, thus requiring the struct blk_trace ->dev field to be set up
at ioctl time, but I'm just trying to figure out how to remove the
requirement of a setup routine for the tracepoints to know what is the
dev_t associated with the request_queue they are getting as a parameter.

Best Regards,

- Arnaldo
