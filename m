Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbYJAIfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbYJAIfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYJAIfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:35:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51883 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYJAIfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:35:45 -0400
Date: Wed, 1 Oct 2008 10:35:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: [PATCH -tip] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081001083532.GE31009@elte.hu>
References: <20081001080048.GB25832@elte.hu> <1222848842-10798-1-git-send-email-steven@uplinklabs.net> <f488382f0810010133j50f70705w59f207434a6b025e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810010133j50f70705w59f207434a6b025e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Noonan <steven@uplinklabs.net> wrote:

> On Wed, Oct 1, 2008 at 1:14 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> > -       u32 scratch;
> > +       u32 uninitialized_var(scratch);
> 
> A bit of a further explanation:
> 
> The variable 'scratch' is always initialized before it's used. The
> conditional which is responsible for initialization of 'scratch' will
> always evaluate 'true' when the first loop iteration occurs, and thus,
> it's properly initialized. GCC doesn't see this, of course, so using
> the uninitialized_var() macro seems to work for silencing this case.

another small workflow suggestion: when you add explanation for the 
changelog it's better to just include the updated patch (dont worry 
about the duplication) - that way maintainers dont have to cut&slice the 
patch and the description toghether. [which is not just a matter of 
wasting time, but if you do tons of patch juggling, it becomes a real 
risk factor.]

	Ingo
