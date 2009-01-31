Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZAaQop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZAaQop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 11:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZAaQog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 11:44:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38197 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbZAaQog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 11:44:36 -0500
Date: Sat, 31 Jan 2009 17:44:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
Message-ID: <20090131164410.GA11189@elte.hu>
References: <1233385816.17794.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233385816.17794.16.camel@localhost.localdomain>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> These are clean patches, I did not included anything which leads to any
> confusion or conflicts. I hope maintainers do not mind if these patches
> go to mainstream via Ingo's -tip along with other headers_check fixes.
> 
> Ingo please pull:
> The following changes since commit 83c21698257b3bbd96926480b26eaffb5a8c3946:
>   Ingo Molnar (1):
>         Merge branch 'x86/apic'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

looks good, but could you please do this like you did the previous one: 
i.e. against your previous tree which was against Linus's tree?

The tree you did above includes a ton of other in-work trees that are in 
-tip, which orders your fixes to after those trees - i.e. to somewhere in 
the late 2.6.30 merge cycle.

So it's better to keep these separate. You can do this by basing your tree 
on tip:core/header-fixes:

   git checkout -b my-new-tree tip/core/header-fixes

That will give you a base of your previous tree (in a Git friendly way), 
plus Sam's fix.

Then you can git-cherry-pick all your new commits into that new tree, and 
send a pull request if you are happy with it. Likewise, you can probably 
achieve the same (with a lot less work) by doing this in your master 
branch above:

   git rebase --onto tip/core/header-fixes tip/master

(this assumes you have -tip set up as a remote repository.)

	Ingo
