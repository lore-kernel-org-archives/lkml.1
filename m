Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZIJR0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZIJR0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 13:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZIJR0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 13:26:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbZIJR0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 13:26:47 -0400
Date: Thu, 10 Sep 2009 19:26:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] Xen bugfixes
Message-ID: <20090910172629.GA10689@elte.hu>
References: <4AA83F99.5040401@goop.org> <20090910051648.GA1335@elte.hu> <4AA93466.6020607@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA93466.6020607@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 09/09/09 22:16, Ingo Molnar wrote:
> >> +# Make sure __phys_addr has no stackprotector
> >> +nostackp := $(call cc-option, -fno-stack-protector)
> >> +CFLAGS_ioremap.o		:= $(nostackp)
> >> +
> >>     
> > Sure we could move __phys_addr into its own file and thus avoid 
> > turning off stackprotector for the rest of ioremap.c?
> >   
> 
> I'm not very keen on having zillions of tiny files just to cope 
> with the lack of per-function stackprotector disable.  I don't see 
> any code in ioremap.c that would really benefit from 
> stack-protector anyway; there are no local arrays.
> 
> At least __phys_addr and friends aren't terribly closely related 
> to ioremap so it would at least make some sense.

Agreed, i wouldnt do it just for the stackprotector benefit (it's 
really stupid that GCC does not allow per function exceptions) - but 
here __phys_addr() looked out of place a bit.

> [...]  Patch below.

Looks like a nice cleanup. Mind sticking it into your next pull 
request?

> >> +CFLAGS_mmu.o			:= $(nostackp)
> >>     
> > A similar argument could be made here - what proportion of mmu.c is 
> > affected?
> 
> More.  It would be a fairly arbitrary chunk of code to split out 
> into a separate file.

Ok - i'd not do it then.

> > Also, once the commits have hit upstream feel free bounce them 
> > to stable@kernel.org - they dont have Cc: <stable@kernel.org> 
> > tags for automatic back-merging requests. The fixes narrowly 
> > missed v2.6.31.
> >   
> 
> Will do.

Thanks,

	Ingo
