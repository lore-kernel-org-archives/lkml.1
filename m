Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbXJaVxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbXJaVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754844AbXJaVxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:53:06 -0400
Received: from ns1.suse.de ([195.135.220.2]:56422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbXJaVxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:53:05 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] sched: high-res preemption tick
From: Andi Kleen <andi@firstfloor.org>
References: <20071031211030.310581000@chello.nl>
	<20071031211249.142859000@chello.nl>
Date: Wed, 31 Oct 2007 22:53:04 +0100
In-Reply-To: <20071031211249.142859000@chello.nl> (Peter Zijlstra's message of "Wed\, 31 Oct 2007 22\:10\:33 +0100")
Message-ID: <p73bqaf2bpb.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> Use HR-timers (when available) to deliver an accurate preemption tick.
>
> The regular scheduler tick that runs at 1/HZ can be too coarse when nice
> level are used. The fairness system will still keep the cpu utilisation 'fair'
> by then delaying the task that got an excessive amount of CPU time but try to
> minimize this by delivering preemption points spot-on.

This might be costly when hrtimers happen to use an more expensive
to reprogram time source. Even an APIC timer access is fairly slow. 
And you'll potentially add the to lots of context switces.

Not sure that is a good idea for performance in general.

-Andi
