Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbYGRL1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbYGRL1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbYGRL05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:26:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55005 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbYGRL04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:26:56 -0400
Date: Fri, 18 Jul 2008 13:26:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dmitry.adamushko@gmail.com, a.p.zijlstra@chello.nl, rostedt@goodmis.org,
       vegard.nossum@gmail.com
Subject: Re: [PATCH] cpu hotplug: Make cpu_active_map synchronization
	dependency clear
Message-ID: <20080718112635.GA6875@elte.hu>
References: <1216180586-8313-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216180586-8313-1-git-send-email-maxk@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> This goes on top of the cpu_active_map (take 2) patch.

i've applied it to sched/devel. Note that checkpatch caught:

> +	/* Make sure the all cpus did the reschedule and are not
> +	 * using stale version of the cpu_active_map.
> +	 * This is not strictly necessary becuase stop_machine() 
> +	 * that we run down the line already provides the required 
> +	 * synchronization. But it's really a side effect and we do not 
> +	 * want to depend on the innards of the stop_machine here. */
> +	synchronize_sched();

this had both whitespace problems (trailing spaces) and basic formatting 
problems. I fixed these up.

	Ingo
