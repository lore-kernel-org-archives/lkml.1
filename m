Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbZHHPnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbZHHPnN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZHHPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:43:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZHHPnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:43:00 -0400
Date: Sat, 8 Aug 2009 17:42:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       LKML <linux-kernel@vger.kernel.org>, borislav.petkov@amd.com
Subject: Re: [PATCH] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
Message-ID: <20090808154246.GK28892@elte.hu>
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090808152016.GB25374@liondog.tnic>
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


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> > +
> > +		/*
> > +		 * Some BIOSes incorrectly set this feature, but only
> > +		 * Revision E (with Extended Model = 2) actually supports
> > +		 * it.
> > +		 */
> > +		if (!(level & 0x00020000))
> > +			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
> 
> let me check this internally next week because it seems that 
> according to the Fam 0xf RevGuide 
> (http://support.amd.com/us/Processor_TechDocs/25759.pdf) erratum 
> 110 applies to atleast 3 CPU revisions with extended model 0x1 
> too.

Ok, mind resending the patch (or dropping it) if you figured that 
out? We need to be careful about restoring CPU erratum workarounds 
that BIOSen install ... these things are very hard to test and easy 
to get wrong.

	Ingo
