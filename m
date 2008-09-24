Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbYIXIRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbYIXIRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYIXIRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:17:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32821 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYIXIRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:17:10 -0400
Date: Wed, 24 Sep 2008 10:15:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       venkatesh.pallipadi@intel.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86, cpa: cpa related changes to be inline with
	TLB Application note - v2
Message-ID: <20080924081511.GB19354@elte.hu>
References: <20080923210035.413932000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923210035.413932000@linux-os.sc.intel.com>
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


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> v2:
>  1. Fix the deadlock associated with smp call function and spin_lock_irqsave()
>     for pgd_lock.
>  2. No alias checks for __set_pages_np()/__set_pages_p() avoiding the large
>     text page split from atomic context in CONFIG_DEBUG_PAGEALLOC.
>  3. Serialize cpa() for !CONFIG_DEBUG_PAGEALLOC, so that a cpu with stale
>     large page tlb's(but small PTE's in memory) won't do a cpa() in parallel
>     to some other cpu splitting large pages and changing page attribute for
>     a small page.

ok, looks good and the code got simpler as well. I've started testing it 
in tip/master and will push out these updates to tip/x86/pat if they 
pass. (v1 had stability problems)

Thanks,

	Ingo
