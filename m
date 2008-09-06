Return-Path: <linux-kernel-owner+w=401wt.eu-S1752483AbYIFQuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbYIFQuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYIFQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:50:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbYIFQuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:50:08 -0400
Date: Sat, 6 Sep 2008 18:49:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/cpu.c: Move the CPU_DYING notifiers
Message-ID: <20080906164949.GB4856@elte.hu>
References: <200808311809.m7VI9whf014532@mail.q-ag.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808311809.m7VI9whf014532@mail.q-ag.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0490]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Manfred Spraul <manfred@colorfullife.com> wrote:

> -	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
> -				param->hcpu);
>  	/* Ensure this CPU doesn't handle any more interrupts. */
>  	err = __cpu_disable();
>  	if (err < 0)
>  		return err;
>  
> +	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
> +				param->hcpu);

hm, doesnt this break things like CPU cross-calls done in CPU_DYING 
callbacks?

	Ingo
