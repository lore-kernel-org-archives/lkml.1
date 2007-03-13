Return-Path: <linux-kernel-owner+w=401wt.eu-S965660AbXCMJj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965660AbXCMJj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXCMJj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:39:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660AbXCMJjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:39:25 -0400
Date: Tue, 13 Mar 2007 10:39:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313093914.GA10533@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <200703130549.47058.kernel@kolivas.org> <1173730314.6431.30.camel@Homer.simpson.net> <200703130738.19034.kernel@kolivas.org> <1173732344.6431.54.camel@Homer.simpson.net> <8cd998d50703121551u44ea3d85g2541503373f461f4@mail.gmail.com> <1173762639.7944.45.camel@Homer.simpson.net> <20070313081805.GA22327@elte.hu> <1173778398.6810.21.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173778398.6810.21.camel@Homer.simpson.net>
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


* Mike Galbraith <efault@gmx.de> wrote:

> I just retested with the encoders at nice 0, and the x/gforce combo is 
> terrible. [...]

ok. So nice levels had nothing to do with it - it's some other 
regression somewhere. How does the vanilla scheduler cope with the 
exactly same workload? I.e. could you describe the 'delta' difference in 
behavior - because the delta is what we are interested in mostly, the 
'absolute' behavior alone is not sufficient. Something like:

 - on scheduler foo, under this workload, the CPU hogs steal 70% CPU 
   time and the resulting desktop experience is 'choppy': mouse pointer 
   is laggy and audio skips.

 - on scheduler bar, under this workload, the CPU hogs are at 40% 
   CPU time and the desktop experience is smooth.

things like that - we really need to be able to see the delta.

> [...]  Funny thing though, x/gforce isn't as badly affected with a 
> kernel build.  Any build is quite noticable, but even at -j8, the 
> effect doen't seem to be (very brief test warning applies) as bad as 
> with only the two encoders running.  That seems quite odd.

likewise, how does the RSDL kernel build behavior compare to the vanilla 
scheduler's behavior? (what happens in one that doesnt happen in the 
other, etc.)

	Ingo
