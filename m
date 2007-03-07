Return-Path: <linux-kernel-owner+w=401wt.eu-S1161339AbXCGIyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbXCGIyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:54:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161338AbXCGIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:54:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161339AbXCGIyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:54:04 -0500
Date: Wed, 7 Mar 2007 09:53:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307085323.GB27337@elte.hu>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de> <20070307082755.GA25733@elte.hu> <20070307003520.08b1a082.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307003520.08b1a082.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > btw., if we decide that nonlinear isnt worth the continuing 
> > maintainance pain, we could internally implement/emulate 
> > sys_remap_file_pages() via a call to mremap() and essentially 
> > deprecate it, without breaking the ABI - and remove all the 
> > nonlinear code. (This would split fremap areas into separate vmas)
> > 
> 
> I'm rather regretting having merged it - I don't think it has been 
> used for much.
> 
> Paolo's UML speedup patches might use nonlinear though.

yes, i wrote the first, prototype version of that for UML, it needs an 
extended version of the syscall, sys_remap_file_pages_prot():

 http://redhat.com/~mingo/remap-file-pages-patches/remap-file-pages-prot-2.6.4-rc1-mm1-A1

i also wrote an x86 hypervisor kind of thing for UML, called 
'sys_vcpu()', which allows UML to execute guest user-mode in a box, 
which also relies on sys_remap_file_pages_prot():

 http://redhat.com/~mingo/remap-file-pages-patches/vcpu-2.6.4-rc2-mm1-A2

which reduced the UML guest syscall overhead from 30 usecs to 4 usecs 
(with native syscalls taking 2 usecs, on the box i tested, years ago).

So it certainly looked useful to me - but wasnt really picked up widely. 

We'll always have the option to get rid of it (and hence completely 
reverse the decision to merge it) without breaking the ABI, by emulating 
the API via mremap(). That eliminates the UML speedup though. So no need 
to feel sorry about having merged it, we can easily revisit that 
years-old 'do we want it' decision, without any ABI worries.

	Ingo
