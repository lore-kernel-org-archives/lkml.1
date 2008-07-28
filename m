Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbYG1Inq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbYG1Inq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYG1Ini
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:43:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42501 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1Inh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:43:37 -0400
Date: Mon, 28 Jul 2008 10:43:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080728084314.GB30302@elte.hu>
References: <20080727190601.GA764@elte.hu> <200807281053.58267.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807281053.58267.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 28 July 2008 05:06:01 Ingo Molnar wrote:
> > Linus,
> >
> > Please pull the latest cpus4096-fixes git tree from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > cpus4096
> >
> > this fixes the cpumask_of_cpu API fallout described here:
> >
> >    http://lkml.org/lkml/2008/7/23/76
> >
> > ... and the fix is wider than i'd like it to be, so close to -rc1
> 
> Sorry, it's wider because you pushed the last stupid Mike patch.  Over my 
> (obviously too-polite) objections.  Most of this is reverting that, just 
> without actually admitting it.
> 
> > - but it's the cleanest one and it has Rusty's ack as well.
> 
> Not really.  As authored, I intended it as a bandaid for systems with 
> small CPU numbers.  Mike made it always on (tho __initdata on large 
> x86 systems), which IMHO is insane (2MB of initdata?).

well, firstly, please understand that nobody is (and the least i am) 
blaming you for anything. I was the one who picked up the patch from 
Mike and sent it Linuswards so i'm to blame and it's me where the buck 
stops.

I have picked up a patch that you wrote originally that solved a problem 
that was first noticed due to crossing commits in the middle of -rc1, by 
drivers/net/sfc/efx.c aa6ef27ea9 which was authored 10 days ago and sent 
upstream 4 days after that - so there was no linux-next exposure where 
we could have noticed it. The cpumask API changes were in the works for 
months literally, and in linux-next for a long time.
 
That particular cpumask API breakage was dormant (read: nobody in-tree 
used the API as an lvalue up to commit aa6ef27ea9) and only got 
unearthed by that crossing change that made such (valid) use of the API. 
I'd have delayed it all and would have waited for the discussion to play 
out, hadnt it been for that (small) build breakage.
   
The 4 commits which were objected to by Linus were literally scrambled 
together in haste within 4 days, to solve that lvalue problem. And i 
Cc:-ed you on the pull request. If you disagree with or are unsure about 
patches you send out then please do not put a Signed-off-by into them 
but a Not-Yet-Signed-off-by. I _will_ notice that - and even if i dont 
notice it, my scripts will ;)

	Ingo
