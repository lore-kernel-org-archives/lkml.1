Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZIJM6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZIJM6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 08:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbZIJM6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 08:58:14 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:53452 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbZIJM6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 08:58:13 -0400
Date: Thu, 10 Sep 2009 08:57:42 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/7] writeback: balance_dirty_pages() shall write
 more than dirtied pages
Message-ID: <20090910125742.GH5106@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20090909145141.293229693@intel.com>
 <20090909150601.159061863@intel.com>
 <20090909154413.GC7949@duck.suse.cz>
 <20090910014201.GB10957@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910014201.GB10957@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AA8F7CA.00D1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 09:42:01AM +0800, Wu Fengguang wrote:
> On Wed, Sep 09, 2009 at 11:44:13PM +0800, Jan Kara wrote:
> > On Wed 09-09-09 22:51:48, Wu Fengguang wrote:
> > > Some filesystem may choose to write much more than ratelimit_pages
> > > before calling balance_dirty_pages_ratelimited_nr(). So it is safer to
> > > determine number to write based on real number of dirtied pages.
> > > 
> > > The increased write_chunk may make the dirtier more bumpy.  This is
> > > filesystem writers' duty not to dirty too much at a time without
> > > checking the ratelimit.
> >   I don't get this. balance_dirty_pages_ratelimited_nr() is called when we
> > dirty the page, not when we write it out. So a problem would only happen if
> > filesystem dirties pages by set_page_dirty() and won't call
> > balance_dirty_pages_ratelimited_nr(). But e.g. generic_perform_write()
> > and do_wp_page() takes care of that. So where's the problem?
> 
> It seems that btrfs_file_write() is writing in chunks of up to 1024-pages
> (1024 is the computed nrptrs value in a 32bit kernel). And it calls
> balance_dirty_pages_ratelimited_nr() each time it dirtied such a chunk.

I can easily change this to call more often, but we do always call
balance_dirty_pages to reflect how much ram we've really sent down.

-chris

