Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbXCEK7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbXCEK7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:59:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXCEK7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:59:08 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:56760 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933095AbXCEK7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:59:07 -0500
Date: Mon, 5 Mar 2007 19:56:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: John Reiser <jreiser@BitWagon.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070305105629.GA13070@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, John Reiser <jreiser@BitWagon.com>,
	Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com> <20070302221854.GA162@tv-sign.ru> <20070305101231.GA12363@linux-sh.org> <20070305105444.GA85@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305105444.GA85@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 01:54:44PM +0300, Oleg Nesterov wrote:
> On 03/05, Paul Mundt wrote:
> > -	if (current->binfmt->hasvdso)
> > +	if (current->binfmt->hasvdso && current->mm->context.vdso)
> 
> I think this is correct, but a bit strange.
> 
> The "->context.vdso != NULL" check relies on the fact that .vdso == NULL
> after mm_alloc (because arch_setup_additional_pages() doesn' initialize
> it when vdso_enabled == 0, and it has to be != NULL otherwise).
> 
> This means that binfmt->hasvdso in essence is not used, at least for i386.
> Isn't it better to kill ->hasvdso and just use ->context.vdso ? Every usage
> of ->hasvdso should also check ->context.vdso anyway.
> 
That was my thought as well, it looks like it's only needed for x86_64. We
don't look at binfmt->hasvdso on SH at all at least, and it works fine
there.. I left it in in the patch since I figured x86 had a reason for
checking it, but perhaps someone who knows the x86/x86_64 interaction
can comment on this.
