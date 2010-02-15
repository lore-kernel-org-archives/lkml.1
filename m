Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0BOPro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:47:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917Ab0BOPrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:47:41 -0500
Date: Mon, 15 Feb 2010 16:47:51 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, fengguang.wu@intel.com
Subject: Re: [PATCH 2/3] mm: Implement writeback livelock avoidance using
 page tagging
Message-ID: <20100215154751.GG3434@quack.suse.cz>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
 <1265929584-5080-3-git-send-email-jack@suse.cz>
 <20100212113955.4c023130.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212113955.4c023130.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-02-10 11:39:55, Andrew Morton wrote:
> On Fri, 12 Feb 2010 00:06:23 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > The idea is simple: Tag all pages that should be written back
> > with a special tag (TOWRITE) in the radix tree. This can be done
> > rather quickly and thus livelocks should not happen in practice.
> > Then we start doing the hard work of locking pages and sending
> > them to disk only for those pages that have TOWRITE tag set.
> 
> Adding a second pass across all the pages sounds expensive?
  Strictly speaking it's just through the radix tree and only through
branches with DIRTY_TAG set. But yes, there is some additional CPU cost.
I just thought that given the total cost of submitting a page it is
an acceptable increase and the simplification is worth it.
  Would some numbers make you happier? Any suggestion for measurements?
Because I think that even for writes to tmpfs the change will be lost
in the noise...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
