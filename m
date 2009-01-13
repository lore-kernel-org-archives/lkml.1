Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZAMMdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZAMMdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbZAMMda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:33:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34634 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbZAMMd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:33:29 -0500
Date: Tue, 13 Jan 2009 13:33:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>,
       Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113123317.GA29926@elte.hu>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231848016.442.112.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > -	char pad[SMP_CACHE_BYTES];
> > -} ____cacheline_aligned;
> > +	char pad[X86_INTERNODE_CACHE_BYTES];
> > +} ____cacheline_internodealigned_in_smp;
> 
> That will make the below array 8*4096 bytes for VSMP, which pushes the 
> limit for memory savings up to 256 cpus.

VSMP is a clustering solution (default-disabled) that pushes 
L1_CACHE_BYTES to 4096 bytes (4K). That is an extremely large alignment 
that pushes up the BSS size ten-fold (!), so no generic Linux distribution 
enables it. 32K compared to 9MB bloat caused by 4K cachelines is a drop in 
the ocean.

	Ingo
