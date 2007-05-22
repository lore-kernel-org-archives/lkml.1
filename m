Return-Path: <linux-kernel-owner+w=401wt.eu-S1762262AbXEVXv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbXEVXv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbXEVXvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:51:50 -0400
Received: from mail.app.aconex.com ([203.89.192.138]:36148 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756035AbXEVXvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:51:49 -0400
X-Greylist: delayed 2055 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 19:51:49 EDT
Subject: Re: [xfs-masters] Re: 2.6.22-rc1-mm1
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: xfs-masters@oss.sgi.com
Cc: Christoph Hellwig <hch@lst.de>, David Chinner <dgc@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070522104429.GN86004887@sgi.com>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
	 <464B304C.5040104@googlemail.com>
	 <20070516094133.bec04e65.akpm@linux-foundation.org>
	 <20070517020600.GS85884050@sgi.com> <20070517084135.GA8510@lst.de>
	 <464CB577.5080106@googlemail.com> <20070518021114.GV86004887@sgi.com>
	 <20070521101141.GX86004887@sgi.com> <20070521102321.GA2632@lst.de>
	 <20070522104429.GN86004887@sgi.com>
Content-Type: text/plain
Organization: Aconex
Date: Wed, 23 May 2007 09:23:10 +1000
Message-Id: <1179876190.6273.532.camel@edge>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 20:44 +1000, David Chinner wrote:
> 
> > xfs_buf_associate_memory is a mess.  My original plan was to get rid
> of
> > it, but I kept that out to keep that patchset small and easily
> reviable,
> > but it seems like that was a mistake.  My plan is the following:
> > 
> >  - xlog_bread and thus the whole buffer I/O path grows an iooffset
> >    paramater that specifies at which offset into the buffer we start
> >    the actual I/O.  That gets rid of all the
> xfs_buf_associate_memory
> >    memory uses in the log recovery code
> 
> Perhaps a new field in the xfs_buf structure - that way call paths
> don't need to grow extra parameters and potentially increase

Thatd be unfortunate - there are very few iclog buffers relative to
every other metadata buffer, so growing the struct for all of those
too would not be ideal (I remember Steve going on pagebuf shrinking
exercises in the distant past, to fit more of em in memory at once,
I can't remember what benchmark in particular he was using though).

cheers.

-- 
Nathan

