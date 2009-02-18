Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZBRAFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZBRAFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZBRAFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:05:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbZBRAFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:05:24 -0500
Date: Wed, 18 Feb 2009 01:05:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: jeremy@goop.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, gitster@pobox.com,
       caglar@pardus.org.tr
Subject: Re: [PATCH] Add *.rej to .gitignore
Message-ID: <20090218000506.GB12714@elte.hu>
References: <499B1729.5040802@goop.org> <20090217.143824.121552155.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217.143824.121552155.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=BAYES_00,SUBJECT_FUZZY_TION autolearn=no SpamAssassin version=3.2.3
	0.2 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: Jeremy Fitzhardinge <jeremy@goop.org>
> Date: Tue, 17 Feb 2009 11:59:37 -0800
> 
> > *.rej files really are unwanted.  If there are any .rej files, they can be found by
> > some other means (perhaps git itself could warn when committing with *.rej files present,
> > or add some distinct notion of "ignored files" vs "never commit" files).
> > 
> > (This effectively reverts 1f5d3a6b6532e25a5cdf1f311956b2b03d343a48)
> > 
> > Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> I don't know about this.
> 
> I really want to know if there are reject files there if I am 
> checking to see if my tree is clean.
> 
> This has caught many patch application errors for myself 
> personally in the past, so I really don't want git to start 
> silently ignoring those things.
> 
> People should delete reject file explicitly, as they are 
> evidence of a patch that would not apply cleanly.  If you 
> abort trying to add the patch, fine, but cleaning up the 
> reject files is part of that operation.

Well, it depends on the workflow. You are making the assumption 
that everyone is using your workflow, and you are judging them 
based on that false assumption.

In my workflow i never miss .rej files because i use tools that 
_do not allow_ rejects to occur - only if i intentionally force 
them. So i cannot "miss" any .rej files - i generate them very 
consciously so all my attention is on them already.

For example i never use the naked '/usr/bin/patch' tool for 
example (which generates rej files without any forcing) - i 
consider that practice a serious workflow error for various 
reasons.

In fact i prefer to keep .rej files around and not remove them, 
to have some minimal history and to be able to see recent 
rejects and if there's a problem i can still reconstruct whether 
i did a patch conflict resolution incorrectly.

What _can_ happen on the other hand is for a .rej file to get 
into a git repo accidentally - while nobody ever would want them 
to get into any git tree, ever.

So ... by all means this is a sane workflow, and Jeremy and 
Alexey i suspect has a similar workflow as well.

Anyway, the .rej problem can also be solved via the pre-commit 
hook - but unfortunately there's way too much sub-par commits 
from elsewhere in the tree, making consistent use of the 
pre-commit hook quite a challenge.

	Ingo
