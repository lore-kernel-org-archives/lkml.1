Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbXIPR6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbXIPR6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 13:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXIPR6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 13:58:08 -0400
Received: from lazybastard.de ([212.112.238.170]:38853 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbXIPR6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 13:58:07 -0400
Date: Sun, 16 Sep 2007 19:53:52 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916175352.GB2393@lazybastard.org>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070915014449.4f9cdb51.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 September 2007 01:44:49 -0700, Andrew Morton wrote:
> On Tue, 11 Sep 2007 14:12:26 +0200 Jörn Engel <joern@logfs.org> wrote:
> 
> > While I agree with your concern, those numbers are quite silly.  The
> > chances of 99.8% of pages being free and the remaining 0.2% being
> > perfectly spread across all 2MB large_pages are lower than those of SHA1
> > creating a collision.
> 
> Actually it'd be pretty easy to craft an application which allocates seven
> pages for pagecache, then one for <something>, then seven for pagecache, then
> one for <something>, etc.
> 
> I've had test apps which do that sort of thing accidentally.  The result
> wasn't pretty.

I bet!  My (false) assumption was the same as Goswin's.  If non-movable
pages are clearly seperated from movable ones and will evict movable
ones before polluting further mixed superpages, Nick's scenario would be
nearly infinitely impossible.

Assumption doesn't reflect current code.  Enforcing this assumption
would cost extra overhead.  The amount of effort to make Christoph's
approach work reliably seems substantial and I have no idea whether it
would be worth it.

Jörn

-- 
Happiness isn't having what you want, it's wanting what you have.
-- unknown
