Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbYBMCuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbYBMCuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYBMCuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:50:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:35447 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbYBMCuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:50:11 -0500
Date: Tue, 12 Feb 2008 18:47:30 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       bfields@fieldses.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213024730.GA8798@mail.oracle.com>
Mail-Followup-To: David Miller <davem@davemloft.net>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	bfields@fieldses.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
	linville@tuxdriver.com
References: <20080212.173817.111913348.davem@davemloft.net> <alpine.LFD.1.00.0802121743400.2920@woody.linux-foundation.org> <20080212180613.a1a07264.akpm@linux-foundation.org> <20080212.182012.153642549.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.182012.153642549.davem@davemloft.net>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 06:20:12PM -0800, David Miller wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 12 Feb 2008 18:06:13 -0800
> 
> > So perhaps a better workflow would be keep the linux-next trees all
> > messy, and then each developer can consolidate, rebase, join and
> > drop things prior to sending their individual trees to Linus.
> 
> We could do that, but I believe Linus's main point is that if we go
> and change the trees then in the end we're merging in something
> different than what was actually tested, namely all the original trees
> as merged into linux-next.
> 
> And I kind of agree with that.

	Make the distinction earlier.  With ocfs2 and configfs (we got
this scheme from Jeff), we keep the topic branches as "unsafe" - that
is, officially rebaseable .  We merge them all into a big "ALL" branch,
which is also "unsafe".  Andrew pulls this for -mm, and it gets tested 
here.  If there is a brown-paper-bag problem, we can tell the original
author to fix it.  Then we re-pull the topic - effectively a rebase.
The ALL is also rebased.  But that's Ok, it will never go towards Linus.
	When a topic is considered worthy of going upstream, we pull it
to a branch called "upstream-linus".  This branch is *NEVER* rebased.
Now that the topic is in upstream-linus, the original topic branch can't
be rebased either.  So any fixes to that topic going forward will stay
in the history.  Since that topic was pulled into ALL for testing, we
are using the identical commits that got tested.

Joel

-- 

"I have never let my schooling interfere with my education."
        - Mark Twain

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
