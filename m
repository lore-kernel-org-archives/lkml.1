Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbYJFI0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYJFI0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYJFIZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:25:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYJFIZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:25:56 -0400
Date: Mon, 6 Oct 2008 10:25:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Steven Noonan <steven@uplinklabs.net>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sdhci: 'scratch' may be used uninitialized
Message-ID: <20081006082541.GA5001@elte.hu>
References: <20081001083532.GE31009@elte.hu> <1222851025-30619-1-git-send-email-steven@uplinklabs.net> <20081005142819.GB12047@cs181140183.pp.htv.fi> <f488382f0810051553t32a24972ma7baa92605f43772@mail.gmail.com> <20081005231607.GB10747@cs181140183.pp.htv.fi> <f488382f0810051648k14b499ecj9d625c55b38ed2f0@mail.gmail.com> <20081006063035.GA19244@elte.hu> <20081006092722.414a7200@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006092722.414a7200@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0205]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pierre Ossman <drzeus@drzeus.cx> wrote:

> > Correct. Would you be interested in sending a patch for a 
> > (default-off) debug feature that allows the disabling of all the gcc 
> > annotations? That way we can do regular sweeps to determine whether 
> > old annotations are still relevant on latest and greatest GCC.
> 
> How would you find the ones that are no longer needed though?

ideally gcc should not emit _any_ bogus warning. Life is too short to 
comb through crappy warnings and to keep in mind which ones are relevant 
and which ones are not. compiler-intel.h does not make use of the 
annotations for example.

> Perhaps we could make it so that uninitialized_var() itself emits a 
> warning. That way you could turn that option on and check that you 
> always have pairs of warnings.

ok - when CONFIG_CC_DEBUG_ALLOW_WARNINGS=y - and then the work flow 
would be to go for single-occurance warnings and eliminate them (because 
their annotation is moot).

	Ingo
