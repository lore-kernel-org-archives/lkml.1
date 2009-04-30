Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZD3Hab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZD3Hab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZD3HaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:30:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZD3HaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:30:21 -0400
Date: Thu, 30 Apr 2009 09:29:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/irq: using move_irq_desc
Message-ID: <20090430072930.GE16737@elte.hu>
References: <49F6559F.7070005@kernel.org> <20090428101448.GA28495@elte.hu> <49F70FED.3040903@kernel.org> <20090428143254.GA24351@elte.hu> <49F753DF.6040104@kernel.org> <20090429120056.GE11586@elte.hu> <49F87FF3.1090600@kernel.org> <20090429204135.GF21421@elte.hu> <20090429212317.GA30147@elte.hu> <49F8E1DE.9010301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F8E1DE.9010301@kernel.org>
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

> +#if defined(CONFIG_SPARSE_IRQ) && defined(CONFIG_SMP)

> +ifdef CONFIG_SMP
>  obj-$(CONFIG_SPARSE_IRQ) += numa_migrate.o
> +endif

hm, seeing such complicatons calls for the reintroduction 
CONFIG_NUMA_IRQ_DESC - but plese make it a non-interactive
helper kconfig symbol, ok?

I.e. something like this:

config NUMA_IRQ_DESC
        def_bool y
        depends on SPARSE_IRQ && NUMA

this way we dont have yet another .config variant - and still have 
nicer looking #ifdefs and makefile rules.

	Ingo
