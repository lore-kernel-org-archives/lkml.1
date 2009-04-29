Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZD2MCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZD2MCX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZD2MCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:02:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33141 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbZD2MCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:02:13 -0400
Date: Wed, 29 Apr 2009 14:00:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/9] x86/irq: make MSI irq_desc numa aware -v3
Message-ID: <20090429120056.GE11586@elte.hu>
References: <49E68C41.4020801@kernel.org> <20090416090315.GF9813@elte.hu> <49E802CE.5030406@kernel.org> <49E804AD.9020702@kernel.org> <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu> <49F753DF.6040104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F753DF.6040104@kernel.org>
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

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> * Yinghai Lu <yinghai@kernel.org> wrote:
> >>>
> >>>> +#ifdef CONFIG_NUMA_IRQ_DESC
> >>>> +		/* different node ?*/
> >>>> +		if (desc_new->node != node)
> >>>> +			desc = move_irq_desc(desc, node);
> >>>> +#endif
> >>> this should have been CONFIG_NUMA_MIGRATE_IRQ_DESC. But even with 
> >>> that fixed, CONFIG_NUMA_MIGRATE_IRQ_DESC is _removed_ in the #2 
> >>> patch in your series and never reintroduced!
> >> should change that to CONFIG_SPARSE_IRQ
> > 
> > That's sensible too.
> > 
> 
> do you mean add back CONFIG_NUMA_IRQ_DESC?

No, what i thought to be sensible is to make this behavior part of 
CONFIG_SPARSE_IRQ=y. We dont want a zillion of config options.

	Ingo
