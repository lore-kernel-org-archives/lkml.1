Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbXEVLnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbXEVLnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 07:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbXEVLne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 07:43:34 -0400
Received: from verein.lst.de ([213.95.11.210]:55492 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbXEVLne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 07:43:34 -0400
Date: Tue, 22 May 2007 13:42:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       xfs-masters@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
Message-ID: <20070522114231.GA6354@lst.de>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B304C.5040104@googlemail.com> <20070516094133.bec04e65.akpm@linux-foundation.org> <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de> <464CB577.5080106@googlemail.com> <20070518021114.GV86004887@sgi.com> <20070521101141.GX86004887@sgi.com> <20070521102321.GA2632@lst.de> <20070522104429.GN86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522104429.GN86004887@sgi.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 08:44:30PM +1000, David Chinner wrote:
> Perhaps a new field in the xfs_buf structure - that way call paths
> don't need to grow extra parameters and potentially increase
> stack usage. The read path tends to be at the top of the stack
> when it gets blown in the writeback path....

I have some patches to unwind the buffer I/O path, it's a little
to overcomplicated due to historical reasons.

> >    the offset in xlog_sync aswell.
> 
> I don't want to have to introduce a mempool just for one xfs_buf per
> filesystem, so this would need to be able to take a xfs_buf (log->l_xbuf)
> that it clones to....

Yes.  Note that we currently do a non-mempooled allocated for the page
array, which this would cure aswell.
