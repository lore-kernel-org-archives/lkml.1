Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZCJNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZCJNvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZCJNvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:51:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbZCJNvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:51:08 -0400
Date: Tue, 10 Mar 2009 14:50:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 01/11] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090310135018.GB3850@elte.hu>
References: <20090305043440.189041194@linux.vnet.ibm.com> <20090305043740.GB17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305043740.GB17747@in.ibm.com>
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


* prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:


> +static u8			tprio[HB_NUM];	/* Thread bp max priorities */
> +LIST_HEAD(kernel_bps);			/* Kernel breakpoint list */
> +static LIST_HEAD(thread_list);			/* thread_hw_breakpoint list */
> +DEFINE_PER_CPU(struct cpu_hw_breakpoint, cpu_bp);

hm, why do we need the whole 'priority' mechanism? It seems very 
over-designed to me.

The likelyhood of both user-space and kernel-space to use 
hw-breakpoints is very low to begin with. And if they use them, 
the likelyhood of there being more than 4 debugregs required in 
the same context is even lower.

If that happens we shouldnt try to be too smart about them - 
just override user-space ones with kernel space ones and that's 
it. No explicit priorities are needed.

	Ingo
