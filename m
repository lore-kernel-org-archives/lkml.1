Return-Path: <linux-kernel-owner+w=401wt.eu-S933573AbXBXWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573AbXBXWKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbXBXWKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:10:54 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42261 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933570AbXBXWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:10:53 -0500
X-AuditID: d80ac287-9eb9bbb000002978-75-45e0b7edde66 
Date: Sat, 24 Feb 2007 22:10:57 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, dipankar@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: PREEMPT_RCU breaks anon_vma locking ?
In-Reply-To: <20070223224145.GD1630@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0702242204220.4370@blonde.wat.veritas.com>
References: <20070223212303.GA423@tv-sign.ru> <20070223224145.GD1630@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 24 Feb 2007 22:10:52.0698 (UTC) FILETIME=[A5E93FA0:01C75860]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Paul E. McKenney wrote:
> 
> This look like a valid fix to me, at least as long as the lock is never
> dropped in the meantime (e.g., to do I/O).  If the lock -is- dropped in
> the meantime, then presumably whatever is done to keep the page from
> vanishing should allow an rcu_read_unlock() to be placed after each
> spin_unlock(&...->lock) and an rcu_read_lock() to be placed before each
> spin_lock(&...->lock).

Thankfully no complications of that kind, page_lock_anon_vma is static
to mm/rmap.c, and only used to hold the spin lock while examining page
tables of the vmas in the list, never a need to drop that lock at all.
(Until the day when someone reports such a long list that we start to
worry about the latency.)

Hugh
