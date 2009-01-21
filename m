Return-Path: <linux-kernel-owner+w=401wt.eu-S1763680AbZAUK4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763680AbZAUK4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZAUK4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:56:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbZAUK4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:56:41 -0500
Date: Wed, 21 Jan 2009 11:56:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: not allow recursion run_workqueue
Message-ID: <20090121105631.GD25531@elte.hu>
References: <4976EE11.7010007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976EE11.7010007@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 1) lockdep will complain when recursion run_workqueue
> 2) works is not run orderly when recursion run_workqueue
> 
> 3) BUG!
>    We use recursion run_workqueue to hidden deadlock when
>    keventd trying to flush its own queue.
> 
>    It's bug. When flush_workqueue()(nested in a work callback)returns,
>    the workqueue is not really flushed, the sequence statement of
>    this work callback will do some thing bad.
> 
>    So we should not allow workqueue trying to flush its own queue.

That's a nice change. I'm wondering what the existing users are though and 
how difficult they are to fix.

	Ingo
