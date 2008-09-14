Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYINOM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYINOM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 10:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYINOMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 10:12:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57772 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbYINOMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 10:12:50 -0400
Date: Sun, 14 Sep 2008 16:12:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: arjan@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 1/2] x86: track memtype for RAM in page struct
Message-ID: <20080914141230.GB17727@elte.hu>
References: <20080913000003.732756000@linux-os.sc.intel.com> <20080913000051.819383000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080913000051.819383000@linux-os.sc.intel.com>
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


* Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: [patch 1/2] x86: track memtype for RAM in page struct
> 
> Track the memtype for RAM pages in page struct instead of using the 
> memtype list. This avoids the explosion in the number of entries in 
> memtype list (of the order of 20,000 with AGP) and makes the PAT 
> tracking simpler. We are using PG_arch_1 bit in page->flags.

this is in contradiction to this comment:

>  /*
> + * RED-PEN:  TODO: Add PageReserved() check aswell here,
> + * once we add SetPageReserved() to all the drivers using
> + * set_memory_* or set_pages_*

if it's marked PG_arch_1, why is there any need for PageReserved?

> + *
> + * This will help prevent accidentally freeing pages
> + * before setting the attribute back to WB.

setting it PageReserved is a hack. We should set it PG_arch_1 and extend 
the page allocator to emit a kernel warning if a PG_arch_1 page is 
freed.

	Ingo
