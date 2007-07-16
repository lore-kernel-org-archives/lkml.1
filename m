Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbXGPLSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbXGPLSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXGPLSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 07:18:33 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28808 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318AbXGPLSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 07:18:32 -0400
Date: Mon, 16 Jul 2007 13:17:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Flavio Curti <fcu@no-way.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Flavio Curti <lists.fcu@no-way.org>, linux-kernel@vger.kernel.org,
       promise_linux@promise.com
Subject: Re: panics with 16port Promise Supertrack EX Controller
Message-ID: <20070716111749.GE5195@kernel.dk>
References: <20070708225246.GD16285@no-way.org> <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com> <46919688.1050005@yahoo.com.au> <20070715080209.GC21260@no-way.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070715080209.GC21260@no-way.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15 2007, Flavio Curti wrote:
> Hello
> 
> On Mon, Jul 09, 2007 at 11:59:36AM +1000, Nick Piggin wrote:
> > >Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   
> > >(2.6.22-rc7-dorade #1)
> > >>The machine panics
> > >>after some days of running fine, the machine inst heavy loaded.
> > >>The Controller detects as stex device:
> > >kernel BUG at block/as-iosched.c:1084!
> > >
> > >BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
> > Could be a bug in the driver that just happens to be caught by AS checks.
> > If you could test another scheduler (boot with elevator=deadline or 
> > elevator=cfq),
> > it might help give us an idea.
> 
> Ok, I now switched to cfg, and the machine panicd again. Panic attached.
> Any help is appreciated.

It really looks like a stex bug - perhaps it's doing double completions
of a request?

-- 
Jens Axboe

