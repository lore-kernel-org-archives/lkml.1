Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbZHDHpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbZHDHpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 03:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932510AbZHDHph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 03:45:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58801 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbZHDHph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:45:37 -0400
Date: Tue, 4 Aug 2009 09:45:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, reif@earthlink.net,
       sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       x86@kernel.org, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH v2 0/8] sparc: use asm-generic/dma-mapping-common.h and
	pci-dma-compat.h
Message-ID: <20090804074510.GA22900@elte.hu>
References: <20090721160538.GL25756@amd.com> <20090721.121519.239732131.davem@davemloft.net> <20090803055608.GB19428@elte.hu> <20090803.212232.259171216.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803.212232.259171216.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 3 Aug 2009 07:56:08 +0200
> 
> > I'm wondering how sparc32 handles core_kernel_text() & friends? 
> > 
> > Those functions already assume that the bits between _stext and 
> > _etext are all core kernel text and not generic pages freed back 
> > to the buddy.
> 
> They won't work for such pages obviously.  Shows how many sparc32 
> users who trigger this case of actually freeing those pages and 
> using such facilities there actually are :-)

:)

I suspect the other bit is probably that core_kernel_text() really 
didnt use to have any critical use at all - just debugging/lockdep 
mostly. So no functionality broke for people to report.

Such bugs often have years of latency on x86 too - we recently fixed 
one that was there for over a year and nobody noticed:

 4a44bac: symbols, stacktrace: look up init symbols after module symbols

	Ingo
