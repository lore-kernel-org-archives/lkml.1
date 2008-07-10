Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYGJI55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYGJI55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYGJI5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:57:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60973 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYGJI5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:57:48 -0400
Date: Thu, 10 Jul 2008 10:57:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] - Map UV chipset space - pagetable
Message-ID: <20080710085730.GC19918@elte.hu>
References: <20080701194532.GA28405@sgi.com> <20080710013533.e059f556.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710013533.e059f556.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 1 Jul 2008 14:45:32 -0500 Jack Steiner <steiner@sgi.com> wrote:
> 
> > +	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));
> 
> BUG_ON(A || B) is usually a bad idea.  If it goes bang, you'll really wish
> that it had been
> 
> 	BUG_ON(A);
> 	BUG_ON(B);

if you check how it's used:

+       init_extra_mapping_uc(UV_GLOBAL_MMR32_BASE, UV_GLOBAL_MMR32_SIZE);
+       init_extra_mapping_uc(UV_LOCAL_MMR_BASE, UV_LOCAL_MMR_SIZE);

those base/size pairs are really supposed to be aligned on 2MB. I.e. 
this is a really 'impossible' scenario that is not really driven by any 
external factor (hw or driver detail) and a compact check for it is 
acceptable too.

	Ingo
