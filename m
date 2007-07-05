Return-Path: <linux-kernel-owner+w=401wt.eu-S1760089AbXGEOvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089AbXGEOvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbXGEOve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:51:34 -0400
Received: from mail.screens.ru ([213.234.233.54]:34810 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170AbXGEOve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:51:34 -0400
Date: Thu, 5 Jul 2007 18:52:43 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] workqueue: debug flushing deadlocks with lockdep
Message-ID: <20070705145243.GA189@tv-sign.ru>
References: <20070705110744.564273000@sipsolutions.net> <20070705110820.304578000@sipsolutions.net> <20070705143217.GA170@tv-sign.ru> <20070705144047.GA9548@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070705144047.GA9548@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > OTOH. Perhaps we can can forbid such a behaviour? Andrew, do you know 
> > any good example of "keventd trying to flush its own queue" ?
> 
> i'd prefer to make the API a little bit stricter: such recursion is 
> nasty. Btw., what mechanism prevents the second instance of 
> run_workqueue() calling into a work->func() again?

Nothing. work->func() can re-schedule itself and then call flush_workqueue().
We have a "morton gets to eat his hat" check in run_workqueue() though.

So I agree with you, such recursion is indeed bad. Can we forbid this?
In that case this patch is even more perfect :)

Oleg.

