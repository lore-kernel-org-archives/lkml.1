Return-Path: <linux-kernel-owner+w=401wt.eu-S1762295AbYDPOak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762295AbYDPOak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYDPOad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:30:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38097 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbYDPOac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:30:32 -0400
Date: Wed, 16 Apr 2008 16:29:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, prasad@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080416142951.GF24383@elte.hu>
References: <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins> <20080415131744.GA5248@elte.hu> <20080415134705.GB22351@Krystal> <20080415164814.GA15842@elte.hu> <20080415213832.GC7873@Krystal> <20080416131751.GI6304@elte.hu> <20080416064630.22428aea@laptopd505.fenrus.org> <20080416140009.GA13968@Krystal> <20080416072416.7b9ff3d2@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416072416.7b9ff3d2@laptopd505.fenrus.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > Not only does the compare and jmp need to be consecutive, but the 
> > movb $0x0,%al also does. I *could* try to detect specific code 
> > inserted in between, but I really have to make sure I don't get 
> > burned by the compiler inserting a jmp there.
> 
> I wonder if just sticking in 2 barriers around your code make gcc stop 
> moving stuff too much

hm, an extra optimization barrier might have worse effects than even an 
extra instruction. I think if the detection and patching can be made 
100% safe, we dont care about the remaining 4% of markers that gcc 
somehow reorders.

and in parallel gcc folks might want to start helping us achieve 
single-instruction branch points? Currently there's no way to get flags 
values out of inline assembly, except via a register intermediary which 
adds another instruction. For flags that are unaffected by gcc's 
input/output constraint generation code it would make sense to allow 
them to be exported out of inline assembly.

	Ingo
