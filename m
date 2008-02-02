Return-Path: <linux-kernel-owner+w=401wt.eu-S932511AbYBBJRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511AbYBBJRx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757486AbYBBJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:17:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46388 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888AbYBBJRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:17:34 -0500
Date: Sat, 2 Feb 2008 10:17:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 1 of 7] x86: convert pgalloc_64.h from macros to inlines
Message-ID: <20080202091712.GA12044@elte.hu>
References: <0d893168b08e5e0d24c2.1201943113@localhost> <1201943630.1844.17.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201943630.1844.17.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Sat, 2008-02-02 at 01:05 -0800, Jeremy Fitzhardinge wrote:
> >  
> > -#define __pte_free_tlb(tlb,pte) tlb_remove_page((tlb),(pte))
> > -
> > -#define __pmd_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
> > -#define __pud_free_tlb(tlb,x)   tlb_remove_page((tlb),virt_to_page(x))
> > +extern void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte);
> > +extern void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd);
> > +extern void __pud_free_tlb(struct mmu_gather *tlb, pud_t *pud);
> 
> Small question: the extern isn't necessary in headers, is it preferred 
> in linux anyway?

generally yes, to make it more visually separate from inlines, etc.

	Ingo
