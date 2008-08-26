Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbYHZTf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbYHZTf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYHZTfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:35:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYHZTfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:35:12 -0400
Date: Tue, 26 Aug 2008 15:35:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@lst.de>, Peter Zijlstra <peterz@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: [2.6.27-rc4] XFS i_lock vs i_iolock...
Message-ID: <20080826193508.GA17542@infradead.org>
References: <6278d2220808221412x28f4ac5dl508884c8030b364a@mail.gmail.com> <20080825010213.GO5706@disturbed> <48B21507.9050708@sgi.com> <20080825035542.GR5706@disturbed> <1219647573.20732.28.camel@twins> <20080825215532.GB28188@lst.de> <20080826024547.GX5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826024547.GX5706@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 12:45:47PM +1000, Dave Chinner wrote:
> XFS: prevent lockdep false positives when locking two inodes
> 
> If we call xfs_lock_two_inodes() to grab both the iolock and
> the ilock, then drop the ilocks on both inodes, then grab
> them again (as xfs_swap_extents() does) then lockdep will
> report a locking order problem. This is a false positive.
> 
> To avoid this, disallow xfs_lock_two_inodes() fom locking both
> inode locks at once - force calers to make two separate calls.
> This means that nested dropping and regaining of the ilocks
> will retain the same lockdep subclass and so lockdep will
> not see anything wrong with this code.

Looks good.  We probably don't need the #ifdef DEBUG as ASSERT is
debug-only anyway.

