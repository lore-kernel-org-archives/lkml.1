Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXKGMvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXKGMvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 07:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbXKGMvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 07:51:48 -0500
Received: from brick.kernel.dk ([87.55.233.238]:24511 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbXKGMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:51:47 -0500
Date: Wed, 7 Nov 2007 13:50:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick <gentuu@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: fix IOPRIO_CLASS_IDLE delays
Message-ID: <20071107125057.GF5525@kernel.dk>
References: <20071106200510.GA11435@tv-sign.ru> <20071106192611.GS1767@kernel.dk> <20071107134855.GA5947@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107134855.GA5947@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07 2007, Oleg Nesterov wrote:
> On 11/06, Jens Axboe wrote:
> >
> > On Tue, Nov 06 2007, Oleg Nesterov wrote:
> > >
> > > (I guess this patch is not complete, overflow is still possible)
> >
> > Hmm, where would it overflow?
> 
> What if the queue was idle long enough (no !CLASS_IDLE requests) so that
> jiffies wraps into the past wrt ->last_end_request?
> 
> IOW, perhaps something like the patch below makes some sense. Of course,
> this is only a theoretical problem, I'm not sure we really need a fix.

OK I see what you mean, probably pretty much a theoretical problem only.
But that doesn't mean it should be fixed, I've applied your patch. It
also collects the two paths enabling the idle class timer, so I consider
it a cleanup as well as it improves readability.

-- 
Jens Axboe

