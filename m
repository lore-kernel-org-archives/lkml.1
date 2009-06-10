Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZFJLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZFJLOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZFJLOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:14:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44274 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755883AbZFJLON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:14:13 -0400
Date: Wed, 10 Jun 2009 13:13:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Harald Welte <HaraldWelte@viatech.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
Message-ID: <20090610111352.GA4482@elte.hu>
References: <20090609082931.GD25316@prithivi.gnumonks.org> <4A2F353A.9040007@kernel.org> <20090610110244.GE27724@elte.hu> <200906100611.14941.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906100611.14941.lkml@morethan.org>
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


* Michael S. Zick <lkml@morethan.org> wrote:

> On Wed June 10 2009, Ingo Molnar wrote:
> > 
> > * H. Peter Anvin <hpa@kernel.org> wrote:
> > 
> > > Ingo Molnar wrote:
> > > > 
> > > > MSRs should really be enumerated along CPU features. They will be 
> > > > accessed if a CPU offers that CPU feature.
> > > > 
> > > 
> > > Nice in theory, but so many MSRs have to be enumerated with obscure test
> > > combinations, that it really isn't practical in the general case.  That
> > > is why we have the safe MSR variants.
> > > 
> > > > 
> > > > Yeah, the safe read should never fault - there should be all 
> > > > zeroes or an error return.
> > > > 
> > > 
> > > Error return, MSRs #GP if not present.  All zero means a present 
> > > MSR (which is zero.)
> > 
> > yes, of course - i meant the /debug/x86/cpu/* behavior: it should 
> > either result zeroes, or should return -EINVAL. (probably the 
> > latter)
> > 
> 
> Return zeroes - same as hardware case for bits which can't be set. 
> Returning -EINVAL might match a specific bit pattern caller is 
> looking for.

these files are accessed via read(). The -EINVAL is the syscall 
return value. The value (if any) goes into the buffer that is being 
read into. So there's no way to 'match a specific bit pattern' - 
it's two separate spaces.

	Ingo
