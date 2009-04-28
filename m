Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbZD1KQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbZD1KQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbZD1KP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:15:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59938 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541AbZD1KP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:15:56 -0400
Date: Tue, 28 Apr 2009 12:14:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] x86/irq: make MSI irq_desc numa aware -v3
Message-ID: <20090428101448.GA28495@elte.hu>
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F6559F.7070005@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> +#ifdef CONFIG_NUMA_IRQ_DESC
> +		/* different node ?*/
> +		if (desc_new->node != node)
> +			desc = move_irq_desc(desc, node);
> +#endif

this should have been CONFIG_NUMA_MIGRATE_IRQ_DESC. But even with 
that fixed, CONFIG_NUMA_MIGRATE_IRQ_DESC is _removed_ in the #2 
patch in your series and never reintroduced!

I've fixed these two bugs in the series and i'm thinking about 
applying them, but this really makes me think how much testing 
you've put into this code.

You really should check that the feature actually does what you 
think, that it can be enabled and you should also check the 
before/after layout of irq descriptors on a NUMA box.

	Ingo
