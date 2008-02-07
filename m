Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYBGTwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYBGTwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYBGTvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:51:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYBGTvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:51:53 -0500
Date: Thu, 7 Feb 2008 20:51:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] CPU isolation extensions
Message-ID: <20080207195130.GA27482@elte.hu>
References: <47AA9807.7090402@qualcomm.com> <alpine.LFD.1.00.0802070903190.2883@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802070903190.2883@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 6 Feb 2008, Max Krasnyansky wrote:
> >
> > Linus, please pull CPU isolation extensions from
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/maxk/cpuisol-2.6.git 
> > for-linus
> 
> Have these been in -mm and widely discussed etc? I'd like to start 
> more carefully, and (a) have that controversial last patch not merged 
> initially and (b) make sure everybody is on the same page wrt this 
> all..

no, they have not been under nearly enough testing and review - these 
patches surfaced on lkml for the first time one week ago (!). I find the 
pull request totally premature, this stuff has not been discussed and 
agreed on _at all_. None of the people who maintain and have interest in 
this code and participated in the (short) one-week discussion were 
Cc:-ed to the pull request.

I think these patches also need a buy-in from Peter Zijlstra and Paul 
Jackson (or really good reasoning while any objections from them should 
be overriden) - all of whom deal with the code affected by these changes 
on a daily basis and have an interest in CPU isolation features.

Generally i think that cpusets is actually the feature and API that 
should be used (and extended) for CPU isolation - and we already 
extended it recently in the direction of CPU isolation. Most enterprise 
distros have cpusets enabled so it's in use. Also, cpusets has the 
appeal of being commonly used in the "big honking boxes" arena, so 
reusing the same concept for RT and virtualization stuff would be the 
natural approach. It already ties in to the scheduler domains code 
dynamically and is flexible and scalable. I resisted ad-hoc CPU 
isolation patches in -rt for that reason. Also, i'd not mind some 
test-coverage in sched.git as well.

	Ingo
