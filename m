Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbZBWROL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbZBWROL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:14:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbZBWRNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:13:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZBWRNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:13:40 -0500
Date: Mon, 23 Feb 2009 18:13:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, stable@kernel.org,
       akpm@linux-foundation.org, npiggin@suse.de, penberg@cs.helsinki.fi
Subject: Re: [PATCH] Teach RCU that idle task is not quiscent state at boot
Message-ID: <20090223171323.GB27072@elte.hu>
References: <20090223161611.GA9563@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223161611.GA9563@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> This patch fixes a bug located by Vegard Nossum with the aid of
> kmemcheck.
> 
> The boot CPU runs in the context of its idle thread during boot-up.
> During this time, idle_cpu(0) will always return nonzero, which will
> fool Classic and Hierarchical RCU into deciding that a large chunk of
> the boot-up sequence is a big long quiescent state.  This in turn causes
> RCU to prematurely end grace periods during this time.
> 
> This patch changes the rcutree.c and rcuclassic.c rcu_check_callbacks()
> function to ignore the idle tasks as a quiescent state until the
> system_state is no longer SYSTEM_BOOTING.  After this point, the idle
> task really does represent a quiescent state.
> 
> In addition, this patch takes Nick Piggin's suggestion to make the
> system_state global variable be __read_mostly.
> 
> Located-by: Vegard Nossum <vegard.nossum@gmail.com>
> Tested-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  init/main.c         |    2 +-
>  kernel/rcuclassic.c |    4 ++--
>  kernel/rcutree.c    |    4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)

Applied to tip:core/urgent, thanks Paul!

	Ingo
