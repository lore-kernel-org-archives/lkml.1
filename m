Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYAIA2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYAIA2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYAIA20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:28:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51389 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYAIA2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:28:25 -0500
Date: Wed, 9 Jan 2008 01:28:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 00 of 10] x86: unify asm/pgtable.h
Message-ID: <20080109002803.GA3732@elte.hu>
References: <patchbomb.1199829603@localhost> <20080108224244.GA3768@elte.hu> <20080108231226.GA10744@elte.hu> <478405DA.40303@goop.org> <20080108232803.GA19906@elte.hu> <20080108234449.GA24274@elte.hu> <20080109000146.GA29095@elte.hu> <47841194.2010208@goop.org> <20080109002014.GB31289@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109002014.GB31289@elte.hu>
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


> >>>  #define __PAGE_KERNEL_EXEC						\
> >>> -	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_GLOBAL)
> >>> +	(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | _PAGE_ACCESSED)
> >>>     
> >
> > This shouldn't be necessary.  The old 64-bit code defined everything 
> > without _PAGE_GLOBAL, but then used a MAKE_GLOBAL() macro to OR it 
> > in later.  This seemed a bit roundabout to me, so I just put it in 
> > from the outset.

actually, this is wrong.

a couple of places use __PAGE_* values, which you've now changed to 
include the _PAGE_GLOBAL flag.

	Ingo
