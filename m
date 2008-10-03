Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYJCIzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYJCIzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYJCIzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:55:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44346 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978AbYJCIzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:55:40 -0400
Date: Fri, 3 Oct 2008 10:54:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 1/2]Add Variable Page Size and IA64 Support in Intel
	IOMMU: Generic Part
Message-ID: <20081003085450.GA27551@elte.hu>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com> <617E1C2C70743745A92448908E030B2A02AD5AD7@scsmsx411.amr.corp.intel.com> <20081001165725.GA21559@linux-os.sc.intel.com> <20081002082942.GA26084@elte.hu> <A6AD88C3F2289247BE726C37303E1EB88408AE54@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB88408AE54@orsmsx505.amr.corp.intel.com>
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


* Yu, Fenghua <fenghua.yu@intel.com> wrote:

> >What's this all about?  Why do we need #ifdef CONFIG_IA64 here? 
> >Doesn't x86 provide its own readq/writeq implementation?
> 
> This is a comment from Bjorn.
> 
> In my patch, one readq/one writeq are working faster than two 
> readl/two writel on IA64. X86 uses two readl/two writel so that the 
> code works on both x86 and x86-64 although Intel IOMMU only has x86-64 
> version currently. dmar_readq() and dmar_writeq() are in moderate 
> performance critical path.
> 
> Do you think my current implementation is ok to have #ifdef 
> CONFIG_IA64 here? Or I can change X86 to use readq/writeq as well or 
> IA64 uses two readl/two writel for clean code?

yes, clean code is very much preferred for a small detail like this.

	Ingo
