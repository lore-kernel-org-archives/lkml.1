Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab0BOQhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:37:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:38047 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258Ab0BOQhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:37:17 -0500
Date: Tue, 16 Feb 2010 03:37:12 +1100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com
Subject: Re: [PATCH 2/3] mm: Implement writeback livelock avoidance using
 page tagging
Message-ID: <20100215163712.GV5723@laptop>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
 <1265929584-5080-3-git-send-email-jack@suse.cz>
 <20100212113955.4c023130.akpm@linux-foundation.org>
 <20100215154751.GG3434@quack.suse.cz>
 <20100215162127.GU5723@laptop>
 <20100215162453.GA6477@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215162453.GA6477@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:24:53AM -0500, Christoph Hellwig wrote:
> On Tue, Feb 16, 2010 at 03:21:27AM +1100, Nick Piggin wrote:
> > Also, I wonder what you think about leaving the tags dangling when
> > the loop bails out early? I have a *slight* concern about this
> > because previously we never have a tag set when radix_tree_delete
> > is called. I actually had a bug in that code in earlier versions
> > of rcu radix tree that only got found by the user test harness.
> > And another slight concern that it is just a bit ugly to leave the
> > tag. But I can accept that lower CPU overhead trumps ugliness :)
> 
> The XFS inode cache calls radix_tree_delete with a tag set, and
> interestingly enough we're trying to catch a very weird bug in that
> area currently, which seems more or less directly related to the use
> of tags.  But we also had a real locking bug related to tags, so I'm
> not yet sure what the issue is back until I hear back from the bug
> reported and reproducer.

Upon looking at the radix_tree_delete code again, the tag clearing
there seems rather simple so perhaps I misremembered some detail of
that bug I had.

