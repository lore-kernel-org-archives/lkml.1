Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYCaNfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYCaNfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYCaNfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:35:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42317 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbYCaNfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:35:11 -0400
Date: Mon, 31 Mar 2008 15:34:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Message-ID: <20080331133429.GG14636@elte.hu>
References: <200803272353.51901.rjw@sisk.pl> <200803281710.44576.rjw@sisk.pl> <alpine.LFD.1.00.0803280938430.14670@woody.linux-foundation.org> <200803282328.34172.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803282328.34172.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> > This is why I have always been advocating so aggressive culling of 
> > regressions and bug-reports - stale bug-reports are worse than 
> > useless, they actually _hurt_.
> 
> I don't quite agree here.  At least, they indicate that we may have an 
> unfixed problem and the fact that no one has taken care of it doesn't 
> really mean we should generally ignore it.

culling doesnt mean ignoring - it just means de-prioritizing. There's 
four basic bug categories:

1- bugs where there's inactivity on the reporter side. This we should
   de-prioritize - and reactivate them once their activity changes.

2- bugs where there's inactivity on the _maintainer_ side show bad bugs 
   in our process.

3- bugs that are old but have lots of activity are usually the most 
   difficult bugs where both side try their best to get it resolved.

4- bugs that are relatively new can be in any of the above 3 categories, 
   we dont know yet.

so i think we should list bugs in category #3 first: the hardest bugs, 
which need the most eyes. Then should we list #2 - the embarrasing bugs 
where our pocess failed. Then should we list #4 - new, not yet resolved 
bugs which need more eyes - especially in late -rc's. Then comes #1 - 
inactive bugs.

the problem for your scripting is to efficiently parse lkml activity for 
these bugs: which replies are from the "maintainer", and how "active" is 
a thread. So i guess a good heuristic is what you did in your latest 
mail: to reverse sort by age of the bug - but i'd also suggest to list 
too old entries where the bugzilla is not in NEEDINFO state - those 
indicate inactive (or unaware) maintainers.

	Ingo
