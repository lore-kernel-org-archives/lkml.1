Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbYAYKdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbYAYKdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYAYKdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:33:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59679 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbYAYKdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:33:22 -0500
Date: Fri, 25 Jan 2008 11:32:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Huang, Ying" <ying.huang@intel.com>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] x86: fix NX bit handling in change_page_attr
Message-ID: <20080125103256.GR23708@elte.hu>
References: <1201240493.15972.43.camel@caritas-dev.intel.com> <47999089.5080609@goop.org> <20080125084633.GA23708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125084633.GA23708@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> ...
> +       ref_prot = pte_pgprot(pte_mkexec(pte_clrhuge(*kpte)));
> 
> i.e. it now goes through all the proper accessors.

i guess it would be nicer to have the proper accessors to just clear the 
NX bit from ref-prot - instead of re-constructing the *kpte from 
scratch. But i see no other way to do it right now than to access 
pgprot_val() as an lvalue. Jeremy, what would be the best approach here?

	Ingo
