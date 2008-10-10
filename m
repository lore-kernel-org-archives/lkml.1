Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYJJRMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYJJRMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758642AbYJJRMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:12:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35046 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056AbYJJRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:12:31 -0400
Date: Fri, 10 Oct 2008 11:12:15 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081010171214.GG25780@parisc-linux.org>
References: <1223506943-6543-1-git-send-email-yinghai@kernel.org> <20081009211837.GC18444@colo.lackof.org> <20081010114002D.fujita.tomonori@lab.ntt.co.jp> <200810100848.09557.jbarnes@virtuousgeek.org> <86802c440810100919xf79f406x403988da7988edc9@mail.gmail.com> <20081010163350.GF25780@parisc-linux.org> <48EF86E9.8030408@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EF86E9.8030408@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 09:46:33AM -0700, Yinghai Lu wrote:
> Matthew Wilcox wrote:
> > 
> > By the way, commit 8f286c33f1e838d631f4a3260b33efce4bc5973c is a really
> > bad idea.  It is very helpful to see which bitmasks are used by real
> > devices, and which ones aren't.  It should be reverted, IMO.
> 
> why? did you point to wrong commit?

No, that's the commit I meant.

> commit 8f286c33f1e838d631f4a3260b33efce4bc5973c
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Thu Oct 18 03:05:07 2007 -0700
> 
> -#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
> +#define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
>  
> -#define DMA_64BIT_MASK	(~0ULL)
> +/*
> + * NOTE: do not use the below macros in new code and do not add new definitions
> + * here.
> + *
> + * Instead, just open-code DMA_BIT_MASK(n) within your driver

Open-coding DMA_BIT_MASK() within your driver means that we no longer
have a canonical list of DMA masks in one place.  Instead we have to
grep the entire tree and come up with more-or-less complex scripts to
figure out which bit masks are actually in use.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
