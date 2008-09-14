Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYINPaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYINPaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYINPaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:30:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbYINPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:30:06 -0400
Date: Sun, 14 Sep 2008 17:29:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] x86, cpa: cpa related changes to be inline with
	TLB Application note
Message-ID: <20080914152947.GH29290@elte.hu>
References: <20080911203048.929515000@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911203048.929515000@linux-os.sc.intel.com>
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

> TLB Application note[1] says:
> 	
> "The TLBs may contain both ordinary and large-page translations for a 4-KByte
>  range of linear addresses. This may occur if software modifies the paging
>  structures so that the page size used for the address range changes. If the
>  two translations differ with respect to page frame or attributes (e.g.,
>  permissions), processor behavior is undefined and may be implementation 
>  specific. The processor may use a page frame or attributes that correspond to
>  neither translation; it may improperly set or fail to set the dirty bit in the
>  appropriate paging-structure entry.
>  
>  Such undefined behavior is problematic because prefetches and memory accesses
>  that are a result of speculative execution may occur, using the affected range
>  of linear addresses. It is also problematic if software (including the software
>  modifying the paging structures) is accessing data or executing code in the
>  affected range of linear addresses. Software should not write to a
>  paging-structure entry in a way that would change, for any linear address,
>  both the page size and either the page frame or attributes."
> 
> Currently we violate this at:
> 
> a. kernel identity mapping, where large/small pages setup very early in the
>    boot will be split up/merged into large pages along with attribute changes
>    during the direct memory mapping init.
> 
> b. while doing cpa(), potentially we will split large page and change attribute
>    both at the same time.
> 
> Following patches fixes this behavior.
> 
> [1] http://developer.intel.com/design/processor/applnots/317080.pdf
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

applied to tip/x86/pat, thanks Suresh.

	Ingo
