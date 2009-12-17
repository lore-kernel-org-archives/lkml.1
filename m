Return-Path: <linux-kernel-owner+w=401wt.eu-S1765150AbZLQRdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765150AbZLQRdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765119AbZLQRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:33:50 -0500
Received: from THUNK.ORG ([69.25.196.29]:48035 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765116AbZLQRdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:33:49 -0500
Date: Thu, 17 Dec 2009 12:33:27 -0500
From: tytso@mit.edu
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217173327.GF2123@thunk.org>
Mail-Followup-To: tytso@mit.edu, Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	James.Bottomley@suse.de, linux-arch@vger.kernel.org,
	Jens Axboe <jens.axboe@oracle.com>
References: <20091216043618.GB9104@hera.kernel.org>
 <20091217132256.GO28962@bombadil.infradead.org>
 <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain>
 <20091217163036.GE2123@thunk.org>
 <20091217171025.GB10431@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217171025.GB10431@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:10:25PM -0500, Christoph Hellwig wrote:
> On Thu, Dec 17, 2009 at 11:30:36AM -0500, tytso@mit.edu wrote:
> > That's because apparently the iSCSI and DMA blocks assume that they
> > have Real Pages (tm) passed to block I/O requests, and apparently XFS
> > ran into problems when sending vmalloc'ed pages.  I don't know if this
> > is a problem if we pass the bio layer addresses coming from the SLAB
> > allocator, but oral tradition seems to indicate this is problematic,
> > although no one has given me the full chapter and verse explanation
> > about why this is so.
> 
> Actually at least iscsi now has a workaround for that by checking for
> PageSlab.  Back when we deal with the XFS issue that check was only
> available with debug options enabled.  I tried to sort it out by
> agreeing with the block and iscsi folks that either
> 
>  a) we need to send down refcountable pages
>  b) block drivers need to accept kmalloced pages
> 
> I could not get any afreement, and thus we stopped using the kmalloced
> pages in XFS which was easy enough.  A bit later people fixed iscsi,
> but we still don't have formal rules about what is acceptable to the
> block layer.

It would be good to get some formal rules articulated.  Someone has
asserted that the AoE (ATA over Ethernet) driver will barf on
SLAB/kmalloc allocated memory.   True, false?

					- Ted
