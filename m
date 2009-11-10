Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZKJP1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZKJP1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZKJP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:27:41 -0500
Received: from [95.166.99.235] ([95.166.99.235]:44926 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZKJP1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:27:40 -0500
Date: Tue, 10 Nov 2009 16:27:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, aaronc@gelato.unsw.edu.au
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection
	code
Message-ID: <20091110152745.GK8742@kernel.dk>
References: <200911101454.57522.czoccolo@gmail.com> <20091110151431.GI8742@kernel.dk> <x49ocna5rv1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ocna5rv1.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Tue, Nov 10 2009, Corrado Zoccolo wrote:
> >> The core block layer already has code to detect presence of command
> >> queuing devices. We convert cfq to use that instead of re-doing the
> >> computation.
> >
> > There's is the major difference that the CFQ variant is dynamic and the
> > block layer one is not. This change came from Aaron some time ago IIRC,
> > see commit 45333d5. It's a bit of a chicken and egg problem.
> 
> Really?  blk_dequeue_request sure looks like it updates things
> dynamically, but only one way (not queueing -> queueing).  Would it make

Yes of course the block layer one is dynamically on as well. The ideal
goal would be to have every driver use the block layer tagging in which
case we'd know without checking, but alas it isn't so (yet). My point is
that the CFQ variant is dynamically off as well. Corrado presents his
patch as a direct functional equivelant, which it definitely isn't.

> sense to just put CFQ's logic into the block layer so that everyone uses
> the same implementation?  It makes little sense to have two notions of
> whether or not queueing is supported for a device.

The one use in the block layer cares about the static property of the
device, not the current behaviour. So I'm not sure it makes a lot of
sense to unify these. It's not really a case of code duplication either,
the block layer one is two checks and a bit. The cfq variant is a bit
more involved in that it tracks the state continually.

-- 
Jens Axboe

