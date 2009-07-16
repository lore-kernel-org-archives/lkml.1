Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbZGPOO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbZGPOO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 10:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZGPOO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 10:14:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:60382 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZGPOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 10:14:57 -0400
Subject: Re: [PATCH 4/7] sched: Add a preempt count base offset to
 __might_sleep()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1247725694-6082-4-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
	 <1247725694-6082-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 16:14:46 +0200
Message-Id: <1247753686.6586.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 02:28 -0400, Frederic Weisbecker wrote:
> +++ b/include/linux/hardirq.h
> @@ -103,6 +103,13 @@
>   */
>  #define in_atomic()    ((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
>  
> +static inline int current_preempt_equals(int preempt_offset)
> +{
> +       int nested = preempt_count() & ~PREEMPT_ACTIVE;
> +
> +       return (nested == PREEMPT_INATOMIC_BASE + preempt_offset);
> +}

I'm not sure about it being in hardirq.h, I think we should keep this in
sched.c.

Also, I'm not sure about the name, but then I suck at naming too. How
about something like: preempt_count_equals() ?

Other than that the series looks nice and I've got it queued.

