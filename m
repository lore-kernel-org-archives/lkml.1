Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbZF2Tyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbZF2Tyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZF2Tyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:54:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33853 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZF2Tye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:54:34 -0400
Date: Mon, 29 Jun 2009 21:54:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2] RO/NX protection for loadable kernel modules
Message-ID: <20090629195410.GE31577@elte.hu>
References: <817ecb6f0906290816t2537e5des3b78b32c6fd16700@mail.gmail.com> <20090629083051.232bac68@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629083051.232bac68@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 29 Jun 2009 11:16:40 -0400
> Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> 
> > This patch is a logical extension of the protection provided by
> > CONFIG_DEBUG_RODATA to LKMs. The protection is provided by splitting
> > module_core and module_init into three logical parts each and setting
> > appropriate page access permissions for each individual section:
> > 
> >   1. Code: RO+X
> >   2. RO data: RO+NX
> >   3. RW data: RW+NX
> > 
> > In order to achieve proper protection, layout_sections() have been
> > modified to align each of the three parts mentioned above onto page
> > boundary. Next, the corresponding page access permissions are set
> > right before successful exit from load_module(). Further,
> > module_free() have been modified to set module_core or module_init as
> > RW+NX right before calling vfree(). Functionality of this patch is
> > enabled only when CONFIG_DEBUG_RODATA defined at compile time.
> > 
> > This is the second revision of the patch: it have been re-written to
> > reduce the number of #ifdefs and to make it architecture-agnostic.
> > Code formatting have been corrected also.
> > 
> 
> you can still go one step further....
> there is no downside to doing NX at all for modules, except for the 3
> sections now each being page aligned thing. So in principle NX should
> just not be part of any ifdef, only the alignment has any justification
> for being so.
> What you can do in the !CONFIG_OPTION case, is treating the "overlap"
> pages as "most permissive goes"..... if you do that you should have 1
> ifdef in total.
> 
> (and one can still argue that making this an option is not even 
> worth that, and just always do it unconditional)

agreed.

	Ingo
