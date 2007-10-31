Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbXJaIwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbXJaIwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 04:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXJaIwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 04:52:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37987 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbXJaIwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 04:52:38 -0400
Date: Wed, 31 Oct 2007 08:52:37 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 28/33] nfs: teach the NFS client how to treat PG_swapcache pages
Message-ID: <20071031085237.GB4362@infradead.org>
References: <20071030160401.296770000@chello.nl> <20071030160915.377778000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030160915.377778000@chello.nl>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 05:04:29PM +0100, Peter Zijlstra wrote:
> Replace all relevant occurences of page->index and page->mapping in the NFS
> client with the new page_file_index() and page_file_mapping() functions.

As discussed personally and on the list a strong NACK for this.  Swapcache
pages have no business at all ever coming through ->writepage(s).  If you
really want to support swap over NFS that can only be done properly by
adding separate methods to write out and read in pages separated from the
pagecache.  Incidentally that would also clean up the mess we have with
swap files on "normal" filesystems using ->bmap and bypassing the filesystem
later on.

