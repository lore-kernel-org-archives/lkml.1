Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbZJMGEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbZJMGEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZJMGEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:04:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54624 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbZJMGEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:04:14 -0400
Date: Tue, 13 Oct 2009 08:03:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Message-ID: <20091013060312.GA3215@elte.hu>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com> <20091012213229.11898c12@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012213229.11898c12@infradead.org>
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

> On Mon, 12 Oct 2009 21:03:17 -0400
> Siarhei Liakh <sliakh.lkml@gmail.com> wrote:
> 
> > This patch expands functionality of CONFIG_DEBUG_RODATA to set main
> > (static) kernel data area as NX.
> > The following steps are taken to achieve this:
> > 1. Linker script is adjusted so .text always starts and ends on a
> > page boundary 2. Linker script is adjusted so .rodata and .data
> > always start and end on a page boundary
> > 3. void mark_nxdata_nx(void) added to arch/x86/mm/init.c with actual
> > functionality: NX is set for all pages from _etext through _end.
> > 4. mark_nxdata_nx() called from free_initmem() (after init has been
> > released) 5. free_init_pages() sets released memory NX in
> > arch/x86/mm/init.c
> > 
> > The patch have been developed for Linux 2.6.31-rc7 x86 by Siarhei
> > Liakh <sliakh.lkml@gmail.com> and Xuxian Jiang <jiang@cs.ncsu.edu>.
> > 
> 
> I like doing this, but... maybe it is useful to have a diff of the 
> pagetable dump (PT_DUMP config option) to show the effect, in the 
> changelog. That'd be like the proof on the pudding...

That's a good suggestion. Siarhei Liakh, mind doing that?

Thanks,

	Ingo
