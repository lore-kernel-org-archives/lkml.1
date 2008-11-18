Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYKRVjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYKRVjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 16:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbYKRVjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 16:39:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYKRVjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 16:39:15 -0500
Date: Tue, 18 Nov 2008 22:39:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: Fixing improper annotation.
Message-ID: <20081118213902.GC28825@elte.hu>
References: <49193D1A.9040000@numericable.fr> <20081111103649.GA10554@elte.hu> <491962FE.1020805@numericable.fr> <20081111104112.GC10554@elte.hu> <b9df5fa10811111635i1154a9a3la5b9fbcfef4df9dc@mail.gmail.com> <b9df5fa10811131927g56d9887jdda1d1ec0d7f8c07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10811131927g56d9887jdda1d1ec0d7f8c07@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> On 11/12/08, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> > On 11/11/08, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  >
> >  > okay - so i wont apply them until the full scope of the problems here
> >  >  is mapped. We might be best off by marking xsave_cntxt_init() non-init
> >  >  altogether for the time being?
> >
> > But, it's been called from an __init section, it will also trigger an
> >  warning too. So, it
> >   will remain as it was. If we goes to hunt these warnings ( I mean
> >  we've to replace __init __alloc_bootmem() with __cpuinit
> >  __alloc_bootmem() ) , it's not certain when it will stop. Likely , we
> >  need to replace a lots of __init with __cpuinit.
> >
>
> Actually , if we replace __init __alloc_bootmem() with __cpuinit 
> __alloc_bootmem() that doesn't solve the problem. The mentioned 
> warning generates when CONFIG_ARCH_BOOTMEM_NODE=y is set. I think 
> Ingo is right. We can mark xsave_cntxt_init() as non-init. And we 
> could teach modpost to not to generate the warning with __ref. Can 
> we, Ingo ?

sure. Marking stuff non-init is inherently safe as well.

	Ingo
