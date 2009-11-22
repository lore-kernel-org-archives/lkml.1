Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZKVSOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZKVSOs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 13:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbZKVSOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 13:14:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:35283 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752480AbZKVSOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 13:14:47 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+i4IMwwXei/AcUVLC7fBRqY2HGwjBDiw+sbDvc9J
	uDQMIDxza/BdMT
Subject: Re: [patch] sched: add the other missing clock update to
 migrate_task()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258909123.6043.19.camel@marge.simson.net>
References: <1258891879.14325.36.camel@marge.simson.net>
	 <1258895770.28730.528.camel@laptop>
	 <1258909123.6043.19.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 22 Nov 2009 19:14:49 +0100
Message-Id: <1258913689.9457.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-22 at 17:58 +0100, Mike Galbraith wrote:
> On Sun, 2009-11-22 at 14:16 +0100, Peter Zijlstra wrote:
> 
> > We should make double_rq_lock() and double_lock_balance() behave
> > equivalent wrt update_rq_clock().
> > 
> > Current, depending on CONFIG_PREEMPT, double_lock_balance() already
> > updates both rq clocks.
> 
> Hm, right.  Better plan.

Oops, nope.  Consistency is still a good plan, however, that update is
still needed, because it's the case where we're _not_ going to use the
migration thread.

	-Mike

