Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYLVR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYLVR5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 12:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYLVR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 12:57:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYLVR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 12:57:31 -0500
Date: Mon, 22 Dec 2008 12:57:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ring_bufer: fix BUF_PAGE_SIZE
In-Reply-To: <494CBB6D.9070106@cn.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0812221254520.19046@gandalf.stny.rr.com>
References: <4948CADF.6050205@cn.fujitsu.com> <20081218124803.GA31763@elte.hu> <494CBB6D.9070106@cn.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Dec 2008, Lai Jiangshan wrote:

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

I need to rename the BUF_PAGE_SIZE to BUF_SIZE, since it is not really a 
page. I'm moving to keep a header on each page so that I can use splice 
and still be able to process the pages elsewhere. The BUF_SIZE is the size 
of the PAGE - that header.

I think it is too early to move the ringbuffer to bigger than a page sub 
buffers.

-- Steve

