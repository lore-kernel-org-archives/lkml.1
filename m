Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbYLUI4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbYLUI4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYLUI4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:56:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbYLUI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:56:05 -0500
Date: Sun, 21 Dec 2008 09:55:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_bufer: fix BUF_PAGE_SIZE
Message-ID: <20081221085552.GE6395@elte.hu>
References: <4948CADF.6050205@cn.fujitsu.com> <20081218124803.GA31763@elte.hu> <494CBB6D.9070106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494CBB6D.9070106@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0009]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> >> impact: make BUF_PAGE_SIZE changeable.
> >>
> >> Except allocating/freeing page and the code using PAGE_MASK,
> >> all code expect buffer_page's length is BUF_PAGE_SIZE.
> >>
> >> This patch make this behavior more concordant.
> >>
> [...]
> > 
> > hm, why? Non-order-0 allocations are pretty evil - why would we ever want 
> > to do them?
> > 
> > 	Ingo
> > 
> 
> I think since we introduce BUF_PAGE_SIZE instead of PAGE_SIZE for
> buffer_page, we should make it changeable. We can use Non-order-0
> allocations, but it doesn't mean we have to use Non-order-0 allocations.
> 
> In the old codes, these lines confuse me:
> return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
> addr &= PAGE_MASK;
> This patch mostly make the codes concordant.

ah, okay. Steve, any strong feelings against the patch? And we might just 
go for removing BUF_PAGE_SIZE itself instead.

	Ingo
