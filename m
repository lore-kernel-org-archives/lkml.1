Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZIIMhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZIIMhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 08:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZIIMhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 08:37:45 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40598 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbZIIMho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 08:37:44 -0400
Date: Wed, 9 Sep 2009 14:37:46 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "david@fromorbit.com" <david@fromorbit.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "jack@suse.cz" <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090909123746.GB18599@kernel.dk>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <20090909092901.GA24185@localhost> <20090909122805.GA30238@infradead.org> <20090909123223.GB23006@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909123223.GB23006@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09 2009, Wu Fengguang wrote:
> On Wed, Sep 09, 2009 at 08:28:06PM +0800, Christoph Hellwig wrote:
> > On Wed, Sep 09, 2009 at 05:29:01PM +0800, Wu Fengguang wrote:
> > > It seems that balance_dirty_pages() is not coupled with MAX_WRITEBACK_PAGES. 
> > > Instead it uses the much smaller (ratelimit_pages + ratelimit_pages / 2).
> > 
> > With Jen's writeback patches applied balance_dirty_pages does not start
> > writeback itself anymore but calls bdi_start_writeback to let the
> > flusher thread do it.
> > 
> > it would be good if we do any writeback tuning ontop of these patches..
> 
> Ah OK. I'm using latest linux-next and expected his patches to be there..

They are there, have been for months! But I think Christoph is a little
confused, we'll still do writeback inline from balance_dirty_pages(). It
does writeback_inodes_wbc(), which does not schedule async writeout.

So if your patches are based and tested off -next, you should be good.

-- 
Jens Axboe

