Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbZFWKBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbZFWKBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 06:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZFWKBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 06:01:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbZFWKBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 06:01:05 -0400
Date: Tue, 23 Jun 2009 12:00:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] RO/NX protection for loadable kernel modules
Message-ID: <20090623100040.GD30634@elte.hu>
References: <817ecb6f0906181833m77dcbeder76f0e8c6e85555ef@mail.gmail.com> <alpine.LRH.2.00.0906231240060.31540@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0906231240060.31540@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> On Thu, 18 Jun 2009, Siarhei Liakh wrote:
> 
> > This patch is a logical extension of the protection provided by
> > CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> > module_core and module_init into three logical parts each and setting
> > appropriate page access permissions for each individual section:
> > 
> >    1. Code: RO+X
> >    2. RO data: RO+NX
> >    3. RW data: RW+NX
> > 
> > In order to achieve proper protection, layout_sections() have been
> > modified to align each of the three parts mentioned above onto page
> > boundary. Next, the corresponding page access permissions are set
> > right before successful exit from load_module(). Further,
> > module_free() have been modified to set module_core or module_init as
> > RW+NX right before calling vfree(). Functionality of this patch is
> > enabled only when CONFIG_DEBUG_RODATA defined at compile time.
> > 
> 
> This looks potentially useful to me, but I'm not an x86 expert 
> (several now added to Cc:).

Pinged a few folks about this already. It looks useful, with the 
main worry being:

 1) the increase in effective module size (probably worth the price)
 2) some uglies in the patch (fixable)

The main ugliness is the excessive use of #ifdefs - those should be 
eliminated. Also, most scripts/checkpatch.pl warnings about this 
patch should be taken seriously.

	Ingo
