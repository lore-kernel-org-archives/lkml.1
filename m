Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYIHR03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYIHR03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbYIHR0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:26:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47051 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbYIHR0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:26:21 -0400
Date: Mon, 8 Sep 2008 19:26:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Manfred Spraul <manfred@colorfullife.com>,
       "David S. Miller" <davem@davemloft.net>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/cpu.c: create a CPU_STARTING cpu_chain notifier
Message-ID: <20080908172602.GF17881@elte.hu>
References: <200809081710.m88HAgXl015314@mail.q-ag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809081710.m88HAgXl015314@mail.q-ag.de>
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


* Manfred Spraul <manfred@colorfullife.com> wrote:

> Right now, there is no notifier that is called on a new cpu, before 
> the new cpu begins processing interrupts/softirqs. Various kernel 
> function would need that notification, e.g. kvm works around by 
> calling smp_call_function_single(), rcu polls cpu_online_map.
> 
> The patch adds a CPU_STARTING notification. It also adds a helper 
> function that sends the message to all cpu_chain handlers.
> 
> Tested on x86-64.
>
> All other archs are untested. Especially on sparc, I'm not sure if I 
> got it right.

applied to tip/sched/cpu-hotplug - thanks Manfred, nice cleanup. (FYI, i 
fixed up the 3 problems that checkpatch reported)

David, can you see any problems with the Sparc32 bits?

	Ingo
