Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYINPV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYINPV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbYINPVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:21:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47773 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYINPVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:21:48 -0400
Date: Sun, 14 Sep 2008 17:21:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kmemcheck: lazy checking for MOVS instructions
Message-ID: <20080914152136.GF29290@elte.hu>
References: <20080911154616.GA16042@localhost.localdomain> <20080912090607.GA6632@elte.hu> <19f34abd0809121009o81f2705ve083209a4af23b5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0809121009o81f2705ve083209a4af23b5d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Fri, Sep 12, 2008 at 11:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> From: Vegard Nossum <vegard.nossum@gmail.com>
> >> Date: Thu, 11 Sep 2008 17:31:07 +0200
> >> Subject: [PATCH] kmemcheck: lazy checking for MOVS instructions
> >>
> >> This patch adds the support for lazy (as opposed to eager) checking
> >> for [REP] MOVS instructions (mostly used in memcpy()). This means that
> >> if both the source and destination addresses are tracked by kmemcheck,
> >> we copy the shadow memory instead of checking that it is initialized.
> >>
> >> In this way, we get rid of a few more false positives.
> >
> > looks good to me. I've applied it to tip/kmemcheck - but can zap it and
> > pull your for-tip branch as well.
> 
> Please zap, I believe it contains an error :-)
> 
> In short, when reading/writing the shadow memory of the second page in 
> a page-boundary-crossing memory access, the offsets into the second 
> shadow page will be wrong (off by up to 8 bytes). It's a pretty 
> obscure case, but it would be nice to have it fixed. Will send a pull 
> request later.

ok, zapped it.

	Ingo
