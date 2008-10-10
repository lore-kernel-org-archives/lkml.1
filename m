Return-Path: <linux-kernel-owner+w=401wt.eu-S1764873AbYJJVuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764873AbYJJVuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762908AbYJJVuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:50:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33613 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763630AbYJJVuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:50:09 -0400
Date: Fri, 10 Oct 2008 23:49:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
Subject: Re: [PATCH -mm -v5] Separate atomic_t declaration from
	asm/atomic.h into asm/atomic_def.h
Message-ID: <20081010214958.GA7708@elte.hu>
References: <1223459070.5872.167.camel@yhuang-dev.sh.intel.com> <20081010144335.65d8153b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010144335.65d8153b.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 08 Oct 2008 17:44:30 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
> > From: Huang Ying <ying.huang@intel.com>
> > 
> > asm/atomic.h contains both declaration and implementation of atomic_t.  So
> > there are some implementation related files included in asm/atomic.h.  And
> > atomic_t is a typedef.  Combination of above makes it impossible to use
> > atomic_t in files included by atomic.h.  Such as atomic_t can not be used
> > in linux/kernel.h on i386, because it is included by asm/atomic.h.
> > 
> > It is reasonable to separate declaration from implementation.  So a new
> > file atomic_types.h is added for every architecture to accommodate the
> > declaration of atomic_t.
> > 
> > Includes fixes from Andrew Moton.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > Reviewed-by: Ingo Molnar <mingo@elte.hu>
> 
> The difference between what-i-currently-have and what-you-just-sent is
> below.  It's quite large.
> 
> Can you explain this update please?

i've been giving review feedback to make it all fit into existing 
namespace concepts better. Should have no change in functionality. (But 
i have not tested it)

	Ingo
