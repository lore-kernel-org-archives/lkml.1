Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbZAVLKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbZAVLKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 06:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZAVLKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 06:10:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38529 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZAVLKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 06:10:35 -0500
Subject: Re: [PATCH 2/3] workqueue: not allow recursion run_workqueue
From: Peter Zijlstra <peterz@infradead.org>
To: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com>
References: <497838F0.7020408@cn.fujitsu.com>
	 <20090122093046.GC5891@nowhere> <20090122093649.GD24758@elte.hu>
	 <c62985530901220306p78ea541cs28912a844297b304@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jan 2009 12:10:15 +0100
Message-Id: <1232622615.4890.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 12:06 +0100, Frédéric Weisbecker wrote:

> Ok.
> Oh but I haven't seen that Oleg said he prefered bug_on, because the
> system will deadlock instead....hmm...
> 
> Or perhaps keeping the things like the old way, but with a WARN_ONCE:
> 
> if (cwq->thread == current) {
>                /*
>                 * Don't ever think to flush workqueue from a work
>                 */
>                WARN_ONCE(1);
> 
>                run_workqueue(cwq);
>                active = 1;
> }
> 
> And then, the workqueue will flush...so it will behave correctly but
> will warn on this bad developer idea of flushing from a work.

lockdep already yells at you for doing that, and developers should run
with lockdep enabled -- or at least test stuff with lockdep enabled, so
I'm not exactly seeing what this will buy us.

> Actually I don't understand when Lai says that it will actually not flush.

Yeah, his changelog is an utter mistery to many..

