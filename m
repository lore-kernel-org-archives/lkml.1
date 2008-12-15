Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYLOS1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYLOS1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYLOS05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:26:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:29315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYLOS04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:26:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,225,1228118400"; 
   d="scan'208";a="649957962"
Date: Mon, 15 Dec 2008 10:26:54 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC PATCH crypto] AES: Add support to Intel AES-NI instructions
Message-ID: <20081215182653.GC18346@linux-os.sc.intel.com>
References: <1229054926.5936.160.camel@yhuang-dev.sh.intel.com> <20081212195722.GA24489@Chamillionaire.breakpoint.cc> <1229307542.5936.204.camel@yhuang-dev.sh.intel.com> <20081215033842.GA28499@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215033842.GA28499@gondor.apana.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 07:38:42PM -0800, Herbert Xu wrote:
> On Mon, Dec 15, 2008 at 10:19:02AM +0800, Huang Ying wrote:
> >
> > The general x86 implementation is used as the fall back for new AES-NI
> > based implementation. Because AES-NI can not be used in kernel soft_irq
> > context. If crypto layer is used to access general x86 implementation,
> 
> Why is that? The VIA PadLock also "touches" the SSE state but we still
> use it on softirq paths.
> 
> In fact Suresh told me earlier that your AES instruction wasn't
> going to have the SSE problems that VIA had, is this not the case?

As Huang mentioned, AES instructions touch SSE registers and thus have
different requirements. I agree that we have to do some performance
analysis to come up with the optimized model.

thanks,
suresh
