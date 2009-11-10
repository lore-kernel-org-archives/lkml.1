Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZKJPUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZKJPUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZKJPUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:20:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZKJPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:20:33 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, aaronc@gelato.unsw.edu.au
Subject: Re: [RFC, PATCH] cfq-iosched: remove redundant queuing detection code
References: <200911101454.57522.czoccolo@gmail.com>
	<20091110151431.GI8742@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 10 Nov 2009 10:20:18 -0500
In-Reply-To: <20091110151431.GI8742@kernel.dk> (Jens Axboe's message of "Tue,
	10 Nov 2009 16:14:31 +0100")
Message-ID: <x49ocna5rv1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Tue, Nov 10 2009, Corrado Zoccolo wrote:
>> The core block layer already has code to detect presence of command
>> queuing devices. We convert cfq to use that instead of re-doing the
>> computation.
>
> There's is the major difference that the CFQ variant is dynamic and the
> block layer one is not. This change came from Aaron some time ago IIRC,
> see commit 45333d5. It's a bit of a chicken and egg problem.

Really?  blk_dequeue_request sure looks like it updates things
dynamically, but only one way (not queueing -> queueing).  Would it make
sense to just put CFQ's logic into the block layer so that everyone uses
the same implementation?  It makes little sense to have two notions of
whether or not queueing is supported for a device.

Cheers,
Jeff
