Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbYJYLoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbYJYLoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 07:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbYJYLo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 07:44:27 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47676 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751822AbYJYLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 07:44:26 -0400
Date: Fri, 24 Oct 2008 16:44:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org
Subject: Re: ext3: fix ext3_dx_readdir hash collision handling - Regression
Message-ID: <20081024204446.GA12868@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-kernel@vger.kernel.org, eugene@ibrix.com, msnitzer@ibrix.com,
	akpm@linux-foundation.org
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de> <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 09:08:26AM -0700, Linus Torvalds wrote:
> 
> Hmm. Ted? I have not tried to revert that commit that Markus pinpointed 
> (6a897cf447a83c9c3fd1b85a1e525c02d6eada7d: "ext3: fix ext3_dx_readdir hash 
> collision handling"), but now that I look at that "git bug", I am getting 
> pretty damn sure that it's exactly the same issue, and it's not a git bug 
> at all.

Yep, I can replicate it now.  It appears to only show up if you are
running with an x86_64 kernel.  I normally run with an x86_32 kernel,
so I didn't notice the problem.  The commit in question avoids
returning duplicate entries when there is a hash collision;
unfortunately, it seems to return duplicate entries for any large
directory if you are running on x86_64 (and possibly/probably other
64-bit platforms).  

I'm working on it, and should hopefully have a fix for you soon.  If
this is too annoying, you can revert it and I'll resubmit a fixed
version once I get a fix.

						- Ted
