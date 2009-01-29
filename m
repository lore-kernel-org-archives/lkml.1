Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbZA2FCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbZA2FCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 00:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbZA2FBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 00:01:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbZA2FBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 00:01:46 -0500
Date: Thu, 29 Jan 2009 05:58:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alasdair G Kergon <agk@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC v2][PATCH] create workqueue threads only when needed
Message-ID: <20090129045848.GB5231@redhat.com>
References: <20090128002714.GA5086@nowhere> <20090128030224.GA4867@redhat.com> <20090128233112.GB7631@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090128233112.GB7631@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Frederic Weisbecker wrote:
>
> I was about to retry the same approach but through async functions (kernel/async.c)
> which would have solved the possible deadlock you described and would have made
> the synchronizations easier.
>
> But actually this is only a half solution:
>
> Pointless workqueues stay pointless, even if they don't appear before they run once.
> And moreover this is hiding the real problem: parts of the kernel use dedicated workqueues
> while kevent is sufficient most of the time.
>
> And if there are problems with using the workqueues, because of deadlocks or slow
> works, async functions are a good solution.

Completely agreed.

And. Even if some subsystem really needs its own workqueue, probably it
can use the single-threaded one, but we have a lot of multithreaded wqs.

Oleg.

