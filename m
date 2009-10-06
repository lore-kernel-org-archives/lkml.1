Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbZJFJJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbZJFJJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZJFJJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:09:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZJFJJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:09:25 -0400
Subject: Re: [PATCH 2/2] mlock use lru_add_drain_all_async()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
References: <20091006112803.5FA5.A69D9226@jp.fujitsu.com>
	 <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 11:08:51 +0200
Message-Id: <1254820131.21044.126.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 11:41 +0900, KOSAKI Motohiro wrote:
> Recently, Peter Zijlstra reported RT-task can lead to prevent mlock
> very long time.
> 
>   Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
>   cpu0 does mlock()->lru_add_drain_all(), which does
>   schedule_on_each_cpu(), which then waits for all cpus to complete the
>   work. Except that cpu1, which is busy with the RT task, will never run
>   keventd until the RT load goes away.
> 
>   This is not so much an actual deadlock as a serious starvation case.
> 
> Actually, mlock() doesn't need to wait to finish lru_add_drain_all().
> Thus, this patch replace it with lru_add_drain_all_async().
> 
> Cc: Oleg Nesterov <onestero@redhat.com>
> Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

It was actually Mike Galbraith who brought it to my attention.

Patch looks sane enough, altough I'm not sure I'd have split it in two
like you did (leaves the first without a real changelog too).



