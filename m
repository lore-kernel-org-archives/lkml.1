Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbXJaVtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbXJaVtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXJaVti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:49:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:56170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXJaVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:49:37 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 5/6] sched: SCHED_FIFO/SCHED_RR watchdog timer
From: Andi Kleen <andi@firstfloor.org>
References: <20071031211030.310581000@chello.nl>
	<20071031211249.531637000@chello.nl>
Date: Wed, 31 Oct 2007 22:49:35 +0100
In-Reply-To: <20071031211249.531637000@chello.nl> (Peter Zijlstra's message of "Wed\, 31 Oct 2007 22\:10\:35 +0100")
Message-ID: <p73fxzr2bv4.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> Introduce a new rlimit that allows the user to set a runtime timeout
> on real-time tasks. Once this limit is exceeded the task will receive
> SIGXCPU.

Nice idea.

It would be even nicer if you could allow a couple of them. Partition
the RT priorities into a few classes and have an own limit for each them.

A small number of classes (3-4) would be probably enough and not bloat
the rlimits too much.

I'm thinking of the case where you have different kinds of real
time processes. Like your mp3 player which you want to be slightly
real time, but with a low SIGXCPU limit. 

And then something else real time which is more important and
you would set a higher limit. etc.

-Andi
