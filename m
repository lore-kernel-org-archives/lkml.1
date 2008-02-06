Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbYBFJQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbYBFJQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 04:16:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbYBFJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 04:15:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760127AbYBFJPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 04:15:41 -0500
Date: Wed, 6 Feb 2008 10:15:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: schwidefsky@de.ibm.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
Message-ID: <20080206091525.GA26358@elte.hu>
References: <20071112144009.831296895@de.ibm.com> <20080201151541.8e3e0359.akpm@linux-foundation.org> <1202017020.7208.2.camel@pasglop> <20080202215315.3ac6907d.akpm@linux-foundation.org> <1202121409.31801.7.camel@localhost> <20080204025133.511ac3e2.akpm@linux-foundation.org> <1202222388.25021.20.camel@localhost> <20080205104625.60fa86b0.akpm@linux-foundation.org> <1202288778.31295.2.camel@localhost> <20080206010947.7b3e9d5e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206010947.7b3e9d5e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > urgh, well, thanks for trying.  If there's significant risk factor 
> > > (or hassle) in fixing the macros then I'd suggest we not do it for 
> > > now - it's a separate project.
> > 
> > I'm still at it. I does make sense to convert the damn macros to 
> > inline functions. The question now is the order of things, the macro 
> > cleanup first or the sub-page page tables first? I would prefer the 
> > sub-page page tables first since that code has been hanging around 
> > in -mm for a while and could go upstream after I regenerated the 
> > patch and test compiled it again. We do need it for KVM and we want 
> > to push our KVM patches for s390 soon.
> 
> I'd suggest do the macro ceanup later.  That's the sort of thing which 
> we can/should trickle through arch maintainers.

note that there are ways to stage even API extensions like adding an 
extra 'struct mm_struct *mm' to macros. It takes a temporary ugliness 
like:

 #define __EXTRA_MM_ARG_DEF			, struct mm_struct *mm
 #define __EXTRA_MM_ARG_VAL(arg)		, (arg)

which converted architectures redefine.

and at the end eliminate these compatibility macros from the core, once 
all arches have converted.

so we _could_ stage even something like this.

	Ingo
