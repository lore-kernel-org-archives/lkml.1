Return-Path: <linux-kernel-owner+w=401wt.eu-S933505AbZJMM3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbZJMM3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbZJMM3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:29:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47199 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933014AbZJMM3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:29:11 -0400
Date: Tue, 13 Oct 2009 14:28:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V5] x86: NX protection for kernel data
Message-ID: <20091013122815.GB5561@elte.hu>
References: <817ecb6f0910121803p52a4049ep4a712545d28bba76@mail.gmail.com> <20091012213229.11898c12@infradead.org> <20091013060312.GA3215@elte.hu> <817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0910130435q56fcbf63r82fae9b94f3eb199@mail.gmail.com>
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


* Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> >> I like doing this, but... maybe it is useful to have a diff of the
> >> pagetable dump (PT_DUMP config option) to show the effect, in the
> >> changelog. That'd be like the proof on the pudding...
> >
> > That's a good suggestion. Siarhei Liakh, mind doing that?
> 
> Here you go:
> ===============================================
> --- data_nx_pt_before.txt	2009-10-13 07:26:17.000000000 -0400
> +++ data_nx_pt_after.txt	2009-10-13 07:26:46.000000000 -0400
> @@ -2,12 +2,9 @@
>  0x00000000-0xc0000000           3G                           pmd
>  ---[ Kernel Mapping ]---
>  0xc0000000-0xc0100000           1M     RW             GLB x  pte
> -0xc0100000-0xc048d000        3636K     ro             GLB x  pte
> -0xc048d000-0xc04d0000         268K     RW             GLB x  pte
> -0xc04d0000-0xc04d2000           8K     RW             GLB NX pte
> -0xc04d2000-0xc04d3000           4K     RW             GLB x  pte
> -0xc04d3000-0xc0531000         376K     RW             GLB NX pte
> -0xc0531000-0xc0600000         828K     RW             GLB x  pte
> +0xc0100000-0xc0381000        2564K     ro             GLB x  pte
> +0xc0381000-0xc048d000        1072K     ro             GLB NX pte
> +0xc048d000-0xc0600000        1484K     RW             GLB NX pte
>  0xc0600000-0xf7800000         882M     RW         PSE GLB NX pmd
>  0xf7800000-0xf79fe000        2040K     RW             GLB NX pte
>  0xf79fe000-0xf7a00000           8K                           pte
> ===============================================
> 
> Would you like me to re-post whole patch with this addition?

Yep, v6 with Arjan's ack (once he sends it) would be handy.

	Ingo
