Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbXFNVIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbXFNVIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbXFNVHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:07:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40152 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbXFNVHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:07:53 -0400
Date: Thu, 14 Jun 2007 22:07:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070614210749.GA23514@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
	linux-kernel@vger.kernel.org
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614130645.cabdff1b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 01:06:45PM -0700, Andrew Morton wrote:
> On Thu, 14 Jun 2007 12:38:39 -0700
> clameter@sgi.com wrote:
> 
> > This patchset cleans up the page cache handling by replacing
> > open coded shifts and adds through inline function calls.
> 
> If we never inflict variable PAGE_CACHE_SIZE upon the kernel, these changes
> become pointless obfuscation.
> 
> Let's put our horses ahead of our carts.  We had a lengthy discussion about
> variable PAGE_CACHE_SIZE in which I pointed out that the performance
> benefits could be replicated in a manner which doesn't add complexity to
> core VFS and which provides immediate benefit to all filesystems without
> any need to alter them: populate contiguous pagecache pages with physically
> contiguous pages.
> 
> I think the best way to proceed would be to investigate that _general_
> optimisation and then, based upon the results of that work, decide whether
> further _specialised_ changes such as variable PAGE_CACHE_SIZE are needed,
> and if so, what they should be.

Christophs patches are an extremly useful cleanup and can stand on their
own.  Right now PAGE_CACHE_SIZE and friends are in there and now one can
keep them distinct because their useage is not clear at all.  By making
the macros per-mapping at least the useage is clear.

That beeing said we should do a full conversion so that PAGE_CACHE_SIZE
just goes away, otherwise the whole excercise is rather pointless.
