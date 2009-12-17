Return-Path: <linux-kernel-owner+w=401wt.eu-S1764972AbZLQRKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764972AbZLQRKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764962AbZLQRKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:10:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52892 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbZLQRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:10:29 -0500
Date: Thu, 17 Dec 2009 12:10:25 -0500
From: Christoph Hellwig <hch@infradead.org>
To: tytso@mit.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, hch@infradead.org, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217171025.GB10431@infradead.org>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217163036.GE2123@thunk.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 11:30:36AM -0500, tytso@mit.edu wrote:
> That's because apparently the iSCSI and DMA blocks assume that they
> have Real Pages (tm) passed to block I/O requests, and apparently XFS
> ran into problems when sending vmalloc'ed pages.  I don't know if this
> is a problem if we pass the bio layer addresses coming from the SLAB
> allocator, but oral tradition seems to indicate this is problematic,
> although no one has given me the full chapter and verse explanation
> about why this is so.

Actually at least iscsi now has a workaround for that by checking for
PageSlab.  Back when we deal with the XFS issue that check was only
available with debug options enabled.  I tried to sort it out by
agreeing with the block and iscsi folks that either

 a) we need to send down refcountable pages
 b) block drivers need to accept kmalloced pages

I could not get any afreement, and thus we stopped using the kmalloced
pages in XFS which was easy enough.  A bit later people fixed iscsi,
but we still don't have formal rules about what is acceptable to the
block layer.

