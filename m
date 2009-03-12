Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZCLRH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZCLRH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 13:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZCLRHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 13:07:14 -0400
Received: from THUNK.ORG ([69.25.196.29]:49677 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754936AbZCLRHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:07:12 -0400
Date: Thu, 12 Mar 2009 13:06:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Message-ID: <20090312170653.GC17104@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Daniel Phillips <phillips@phunq.net>, linux-fsdevel@vger.kernel.org,
	tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903122010.31282.nickpiggin@yahoo.com.au> <200903120315.07610.phillips@phunq.net> <200903122203.31502.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903122203.31502.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 10:03:31PM +1100, Nick Piggin wrote:
> It is basically already proven. It is faster with ext2 and it works with
> XFS delalloc, unwritten etc blocks (mostly -- except where I wasn't
> really able to grok XFS enough to convert it). And works with minix
> with larger block size than page size (except some places where core
> pagecache code needs some hacking that I haven't got around to).
> 
> Yes an ext3 conversion would probably reveal some tweaks or fixes to
> fsblock. I might try doing ext3 next. I suspect most of the problems
> would be fitting ext3 to much stricter checks and consistency required
> by fsblock, rather than adding ext3-required features to fsblock.
> 
> ext3 will be a tough one to convert because it is complex, very stable,
> and widely used so there are lots of reasons not to make big changes to
> it.

One possibility would be to do this with ext4 instead, since there are
fewer users, and it has more a "development" feel to it.  OTOH, there
are poeple (including myself) who are using ext4 in production
already, and I'd appreciate not having my source trees on my laptop
getting toasted.  :-)

Is it going to be possible to make the fsblock conversion being
something which is handled via CONFIG_EXT4_FSBLOCK #ifdefs, or are the
changes too invasive to really allow that?  (Also note BTW that ocfs2
is also using jbd2, so we need to be careful we don't break ocfs2
while we're doing the fsblock conversion.)

						- Ted
