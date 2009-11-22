Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZKVQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZKVQ6l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbZKVQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:58:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:56557 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755404AbZKVQ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:58:40 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198sj1dKHB8unsSouGiNrJDFvWvJ/2twPOCkTCEh5
	ywF0E2wqPZKgtX
Subject: Re: [patch] sched: add the other missing clock update to
 migrate_task()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258895770.28730.528.camel@laptop>
References: <1258891879.14325.36.camel@marge.simson.net>
	 <1258895770.28730.528.camel@laptop>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 17:58:43 +0100
Message-Id: <1258909123.6043.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 14:16 +0100, Peter Zijlstra wrote:

> We should make double_rq_lock() and double_lock_balance() behave
> equivalent wrt update_rq_clock().
> 
> Current, depending on CONFIG_PREEMPT, double_lock_balance() already
> updates both rq clocks.

Hm, right.  Better plan.  We can save an update in the wakeup path for
the tasks racing for the wakeup case too.  If the call is really a
lock/unlock go away, we don't need to bother.  Shave a ns or so.

	-Mike

