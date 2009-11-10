Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZKJPla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZKJPla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbZKJPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:41:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756563AbZKJPl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:41:29 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, aaronc@gelato.unsw.edu.au
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection code
References: <200911101454.57522.czoccolo@gmail.com>
	<20091110151431.GI8742@kernel.dk>
	<x49ocna5rv1.fsf@segfault.boston.devel.redhat.com>
	<20091110152745.GK8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Nov 2009 10:41:13 -0500
In-Reply-To: <20091110152745.GK8742@kernel.dk> (Jens Axboe's message of "Tue,
	10 Nov 2009 16:27:45 +0100")
Message-ID: <x49k4xy5qw6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Tue, Nov 10 2009, Jeff Moyer wrote:
>> Jens Axboe <jens.axboe@oracle.com> writes:
>> 
>> > On Tue, Nov 10 2009, Corrado Zoccolo wrote:
>> >> The core block layer already has code to detect presence of command
>> >> queuing devices. We convert cfq to use that instead of re-doing the
>> >> computation.
>> >
>> > There's is the major difference that the CFQ variant is dynamic and the
>> > block layer one is not. This change came from Aaron some time ago IIRC,
>> > see commit 45333d5. It's a bit of a chicken and egg problem.
>> 
>> Really?  blk_dequeue_request sure looks like it updates things
>> dynamically, but only one way (not queueing -> queueing).  Would it make
>
> Yes of course the block layer one is dynamically on as well. The ideal
> goal would be to have every driver use the block layer tagging in which
> case we'd know without checking, but alas it isn't so (yet). My point is
> that the CFQ variant is dynamically off as well. Corrado presents his
> patch as a direct functional equivelant, which it definitely isn't.

OK.  So we really want to keep track of two things:
1) What queue depth does the hardware support?
2) What is the command queue depth configured to?

That second thing can be changed by the administrator (down from or up
to the maximum value allowed by 1).

>> sense to just put CFQ's logic into the block layer so that everyone uses
>> the same implementation?  It makes little sense to have two notions of
>> whether or not queueing is supported for a device.
>
> The one use in the block layer cares about the static property of the
> device, not the current behaviour. So I'm not sure it makes a lot of
> sense to unify these. It's not really a case of code duplication either,
> the block layer one is two checks and a bit. The cfq variant is a bit
> more involved in that it tracks the state continually.

Why don't we simply use the value configured via the queue_depth sysfs
file?

Cheers,
Jeff
