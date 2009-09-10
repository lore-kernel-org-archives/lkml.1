Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZIJExu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZIJExu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750917AbZIJExt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:53:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:57857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZIJExs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:53:48 -0400
Subject: Re: [RFC][PATCH 5/7] writeback: use 64MB MAX_WRITEBACK_PAGES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Theodore Tso <tytso@mit.edu>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20090909232938.GD24951@mit.edu>
References: <20090909145141.293229693@intel.com>
	 <20090909150600.874037375@intel.com>  <20090909232938.GD24951@mit.edu>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 06:53:18 +0200
Message-Id: <1252558398.7205.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 19:29 -0400, Theodore Tso wrote:
> On Wed, Sep 09, 2009 at 10:51:46PM +0800, Wu Fengguang wrote:
> > + * The maximum number of pages to writeout in a single periodic/background
> > + * writeback operation. 64MB means I_SYNC may be hold for up to 1 second.
> > + * This is not a big problem since we normally do kind of trylock on I_SYNC
> > + * for non-data-integrity writes.  Userspace tasks doing throttled writeback
> > + * do not use this value.
> 
> What's your justification for using 64MB?  Where are you getting 1
> second from?  On a fast RAID array 64MB can be written in much less
> than 1 second.

Worse, on my 5mb/s usb stick writing out 64m will take forever.

