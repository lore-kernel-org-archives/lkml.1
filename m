Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbXCNSKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbXCNSKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXCNSKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:10:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35858 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbXCNSJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:09:59 -0400
Date: Wed, 14 Mar 2007 19:09:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 - Take 2
Message-ID: <20070314180933.GA12994@elte.hu>
References: <20070314050819.536207642@goodmis.org> <p73slc8863r.fsf@bingen.suse.de> <20070314125330.GA13168@elte.hu> <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703140850250.9690@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Did you even *look* at the patches?

yes. I am strongly in favor of sharing code - i recently introduced 
arch/x86_64/kernel/tsc_sync.c that is shared by i386 too.

So first i wrote a draft email where i told Andi that he's on crack to 
NACK it so brutally and that we should clearly do arch/x86 ;-)

then i decided to analyze the patches: currently they move 13452 lines 
of code. i386 is 87847 lines of code, x86_64 is 40978 lines of code, a 
total of 128825. That means we move about 10% of the code. Not 
insignificant but not earth-shattering either. With alot more effort 
(and testing) we could realistically go up to maybe 20% - but that's 
still a bit low to spread out all the files, isnt it?

in comparison, arch/powerpc is 159099 lines of code, arch/ppc is 106598 
lines of code. So the sharing factor is quite a bit higher there. I dont 
think we could ever reach that with x86.

So i thought it's a better idea to continue with the current more 
finegrained scheme of sharing some files between the architectures by 
having arch/x86_64 be the 'main' repository, with i386 inheriting them 
back, instead of spreading out the files?

but, whichever variant happens, it's certainly fine to me :)

	Ingo
