Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZAUH1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZAUH1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 02:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZAUH1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 02:27:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268AbZAUH1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 02:27:24 -0500
Date: Wed, 21 Jan 2009 08:27:18 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090121072718.GN24891@wotan.suse.de>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu> <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120205653.GA19710@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 09:56:53PM +0100, Ingo Molnar wrote:
> 
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> >> |       50234816 |     51303520  cache references            +2.12%
> >> |        5428258 |      5583728  cache misses                +2.86%
> >>   
> >
> > Is this I or D, or combined?
> 
> That's last-level-cache references+misses (L2 cache):
> 
>  Bit Position Event Name                UMask Event Select
>  CPUID.AH.EBX
>  3            LLC Reference             4FH   2EH
>  4            LLC Misses                41H   2EH

Oh, _llc_ references/misses? Ouch.

You have, what 32K L1I, 32K L1D, and 4MB L2? And even this microbenchmark
is seeing increased L2 misses by nearly 3%. Hmm, I wonder where that is
coming from? Instruction fetches?

It would be interesting to see how "the oltp" benchmark fares with
CONFIG_PARAVIRT turned on. That workload lives and dies by the cache :)
