Return-Path: <linux-kernel-owner+w=401wt.eu-S1754306AbXIPVcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbXIPVcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXIPVb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:31:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55587 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164AbXIPVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:31:58 -0400
Date: Sun, 16 Sep 2007 22:31:55 +0100
To: J?rn Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916213154.GG16406@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <20070916175352.GB2393@lazybastard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070916175352.GB2393@lazybastard.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/09/07 19:53), J?rn Engel didst pronounce:
> On Sat, 15 September 2007 01:44:49 -0700, Andrew Morton wrote:
> > On Tue, 11 Sep 2007 14:12:26 +0200 Jörn Engel <joern@logfs.org> wrote:
> > 
> > > While I agree with your concern, those numbers are quite silly.  The
> > > chances of 99.8% of pages being free and the remaining 0.2% being
> > > perfectly spread across all 2MB large_pages are lower than those of SHA1
> > > creating a collision.
> > 
> > Actually it'd be pretty easy to craft an application which allocates seven
> > pages for pagecache, then one for <something>, then seven for pagecache, then
> > one for <something>, etc.
> > 
> > I've had test apps which do that sort of thing accidentally.  The result
> > wasn't pretty.
> 
> I bet!  My (false) assumption was the same as Goswin's.  If non-movable
> pages are clearly seperated from movable ones and will evict movable
> ones before polluting further mixed superpages, Nick's scenario would be
> nearly infinitely impossible.
> 

It would be plain impossible from a fragmentation point-of-view but you
meet interesting situations when a GFP_NOFS allocation has no kernel blocks
available to use. It can't reclaim, maybe it can move but not with current
code (it should be able to with the Memory Compaction patches).

> Assumption doesn't reflect current code.  Enforcing this assumption
> would cost extra overhead.  The amount of effort to make Christoph's
> approach work reliably seems substantial and I have no idea whether it
> would be worth it.
> 

Current code doesn't reflect your assumptions simply because the costs are so
high. We'd need to be really sure it's worth it and if the answer is "yes",
then we are looking at Andrea's approach (more likely) or I can check out
evicting blocks of 16KB, 64KB or whatever the large block is.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
