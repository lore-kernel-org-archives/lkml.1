Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbZKLLBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbZKLLBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 06:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZKLLBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 06:01:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbZKLLBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 06:01:42 -0500
Subject: Re: [patch] sched: fix/add missing update_rq_clock() calls
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258020464.6491.2.camel@marge.simson.net>
References: <1258020464.6491.2.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 12:01:45 +0100
Message-ID: <1258023705.4039.103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 11:07 +0100, Mike Galbraith wrote:
> sched: fix/add missing update_rq_clock() calls.
> 
> kthread_bind(), migrate_task() and sched_fork were missing updates, and
> try_to_wake_up() was updating after having already used the stale clock.


I'm almost at the point where I think we should ditch rq->clock
alltogether and simply call cpu_clock() directly when we need it. This
trying to optimize and avoid calling it game has brought way too many
head-aches.

