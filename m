Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYHKRKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYHKRKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYHKRKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:10:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44560 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYHKRKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:10:39 -0400
Date: Mon, 11 Aug 2008 19:10:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [rfc][patch] x86: avoid highmem cache attribute aliasing
Message-ID: <20080811171019.GK4524@elte.hu>
References: <20080801011521.GB20407@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801011521.GB20407@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> Highmem code can leave ptes and tlb entries around for a given page 
> even after kunmap, and after it has been freed.
> 
> From what I can gather, the PAT code may change the cache attributes 
> of arbitrary physical addresses (ie. including highmem pages), which 
> would result in aliases in the case that it operates on one of these 
> lazy tlb highmem pages.
> 
> Flushing kmaps should solve the problem.
> 
> I've also just added code for conditional flushing if we haven't got 
> any dangling highmem aliases -- this should help performance if we 
> change page attributes frequently or systems that aren't using much 
> highmem pages (eg. if < 4G RAM). Should be turned into 2 patches, but 
> just for RFC...

hm, such aliasing might happen in theory - and i guess in practice too 
if the AGP driver allocates/deallocates aperture in short succession. 

Maybe this could corrupt the X framebuffer - or even generic kernel RAM. 
Mind resending the two split up patches? The fix we might want to take 
into v2.6.27, the speedup probably for v2.6.28.

But maybe i'm missing something obvious that prevents such problems on 
32-bit systems - Venki, Suresh, what do you think?

	Ingo
