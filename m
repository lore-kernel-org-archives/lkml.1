Return-Path: <linux-kernel-owner+w=401wt.eu-S1763457AbXGKLgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763457AbXGKLgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759605AbXGKLgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:36:01 -0400
Received: from verein.lst.de ([213.95.11.210]:53900 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbXGKLgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:36:00 -0400
Date: Wed, 11 Jul 2007 13:35:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070711113553.GA18665@lst.de>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710013152.ef2cd200.akpm@linux-foundation.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:31:52AM -0700, Andrew Morton wrote:
> romfs-printk-format-warnings.patch

NACK on this one.  This bloats romfs by almost half of it's previous
size to add mtd support to it.  Given that romfs is a compltely
trivial filesystem it's much better to have a separate filesystem
driver handling the format on mtd instead of adding all these
indirections.  In addition to that argument the switch on the
underlying subsystem is done horrible.  There's lots of ifdefs instead
of proper functions pointers, there's one file containing both block
and mtd code instead of seaparate files, etc.

And the get_unmapped_area method in a bare filesystem needs a _lot_
of explanation.

