Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbZLIId6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbZLIId6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZLIId5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:33:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:50866 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZLIId4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:33:56 -0500
Subject: Re: [patch V2 sched: Protect sched_rr_get_param access to
 task->sched_class
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
References: <20091208202026.804386447@linutronix.de>
	 <1260345648.5489.65.camel@laptop> <1260345798.5489.70.camel@laptop>
	 <alpine.LFD.2.00.0912090905210.3089@localhost.localdomain>
	 <alpine.LFD.2.00.0912090930120.3089@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 09:33:56 +0100
Message-ID: <1260347636.5489.103.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 09:32 +0100, Thomas Gleixner wrote:
> sched_rr_get_param calls task->sched_class->get_rr_interval(task)
> without protection against a concurrent sched_setscheduler() call
> which modifies task->sched_class.
> 
> Serialize the access with task_rq_lock(task) and hand the rq pointer
> into get_rr_interval() as it's needed at least in the sched_fair
> implementation.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

