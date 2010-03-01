Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab0CAILO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:11:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37739 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CAILM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:11:12 -0500
Date: Mon, 1 Mar 2010 09:10:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Greg KH <greg@kroah.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Sage Weil <sage@newdream.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Al Viro <viro@ZenIV.linux.org.uk>, "\"J??rn Engel\"" <joern@logfs.org>
Subject: Re: linux-next: current pending merge fix patches
Message-ID: <20100301081021.GB8049@elte.hu>
References: <20100301160445.5e281f11.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301160445.5e281f11.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> This could also be taken as a reminder to the respective maintiners that 
> they may want to do a merge of your tree before asking you to pull theirs.

I dont think that's generally correct for trivial conflicts: it's better if 
Linus does the merge of a tree that is based in some stable tree.

It causes slightly messier criss-cross history: there will be the back-merge 
commit plus the inevitable merge commit from Linus. It also makes bisection a 
bit messier:

For example when bisecting i generally consider the 'boundary' of where Linus 
pulls as a 'known point of stability': i.e. the 'subsystem side' is expected 
to be well-tested and if there's a problem on that side, it's that subsystem's 
domain.

"Linus's side", during the merge window, is a rolling tree of many freshly 
merged trees, which inevitably piles up a few problems.

So it's IMO somewhat better to keep that boundary and not push out Linus's 
side into subsystem trees: which then may merge a few new patches after having 
merged Linus's tree, intermixing it all into a non-bisectable combination.

Plus there's also an indirect effect: it keeps people from merging back 
Linus's tree all the time.

So i'd argue to not backmerge during the merge window (and i have stopped 
doing that myself a few cycles ago, and it clearly helped things) - but in any 
case it's certainly no big deal and up to Linus i guess.

	Ingo
