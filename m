Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbZJFQd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbZJFQd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932517AbZJFQd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:33:59 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:55252 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932481AbZJFQd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:33:58 -0400
Date: Tue, 6 Oct 2009 12:27:27 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/2] mlock use lru_add_drain_all_async()
In-Reply-To: <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0910061226300.18309@gentwo.org>
References: <20091006112803.5FA5.A69D9226@jp.fujitsu.com> <20091006114052.5FAA.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, KOSAKI Motohiro wrote:

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

Ok so this will queue up lots of events for the cpu doing a RT task. If
the RT task is continuous then they will be queued there forever?
