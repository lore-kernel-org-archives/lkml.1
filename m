Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbZCRK6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbZCRK6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbZCRK6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 06:58:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbZCRK6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 06:58:24 -0400
Subject: Re: [PATCH] posixtimers: Fix posix clock monotonicity v2
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <49C0CFC2.7080604@jp.fujitsu.com>
References: <49BF3F73.5090007@jp.fujitsu.com>
	 <49C0CFC2.7080604@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 18 Mar 2009 11:58:07 +0100
Message-Id: <1237373887.5069.203.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 19:41 +0900, Hidetoshi Seto wrote:
> Impact: Regression fix (against clock_gettime() backwarding bug)
> 
> This patch re-introduces a couple of function, task_sched_runtime
> and thread_group_sched_runtime, which was once removed at the
> time of 2.6.28-rc1.
> 
> These functions protect the sampling of thread/process clock with
> rq lock.  This rq lock is required not to update rq->clock durling
> the sampling.
> i.e.
>   The clock_gettime() may return
>    ((accounted runtime before update) + (delta after update))
>   that is less than what it should be.
> 
> v1 -> v2:
> 	- Revises comments for functions and patch description.
> 	- Add note about accuracy of thread group's runtime.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: stable@kernel.org	[2.6.28.x]

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks Hidetoshi-san.

