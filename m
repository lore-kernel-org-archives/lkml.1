Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbYGWHcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbYGWHcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYGWHcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:32:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56204 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbYGWHcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:32:46 -0400
Date: Wed, 23 Jul 2008 09:32:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [git pull] x86: declaration fixes - ver2
Message-ID: <20080723073233.GA21172@elte.hu>
References: <1216786052.2602.2.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216786052.2602.2.camel@jaswinder.satnam>
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> Here are updated patches for x86-tip.
> 
> The following changes since commit a099a9b18ab434594bb01ed920e8c58574203fa9:
>   Ingo Molnar (1):
>         Merge branch 'out-of-tree'

looks good, but could you please switch over the changes to be based on 
the "upstream" topic branch of your patches, i.e. to tip/x86/prototypes?

You can do it the following way:

  git checkout master
  git merge tip/master                                  # get latest
  git checkout -b x86/prototypes-for-tip                # new pull branch
  git rebase --onto tip/x86/prototypes tip/master       # switch

In theory this should run just fine without any conflicts or manual 
intervention needed.

If that rebase command ran fine, double-check the end result by looking 
at the output of:

  git log tip/x86/prototypes..x86/prototypes-for-tip

... then resend the pull request for the x86/prototypes branch you have, 
by doing something like:

git-request-pull tip/x86/prototypes git://git.infradead.org/users/jaswinder/linux-2.6-tip.git x86/prototypes-for-tip

The reason for not basing your branch on tip/master is that we want to 
keep x86/protypes topic a "pure" topic that is mergable without waiting 
for other topics - without mixing it with all other topics that are 
integrated into tip/master.

And note that x86/prototypes-for-tip is a by-line branch that you should 
not touch after sending the pull request (so that what i pull matches up 
to the summary in the email you send) - you can still evolve your master 
branch with other work, create other branches, etc.

Let me know if there's any Git hickup.

Thanks,

	Ingo
