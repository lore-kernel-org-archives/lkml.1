Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbXHEUed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbXHEUed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXHEUeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:34:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34652 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbXHEUeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:34:24 -0400
Date: Sun, 5 Aug 2007 21:34:13 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       J?rn Engel <joern@logfs.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805203413.GA25107@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Arjan van de Ven <arjan@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	J?rn Engel <joern@logfs.org>, Ingo Molnar <mingo@elte.hu>,
	Jeff Garzik <jeff@garzik.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk, david@lang.hm
References: <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org> <alpine.LFD.0.999.0708041246530.5037@woody.linux-foundation.org> <1186258399.2777.8.camel@laptopd505.fenrus.org> <20070804214821.GC11150@thunk.org> <1186336878.2777.15.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186336878.2777.15.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 11:01:18AM -0700, Arjan van de Ven wrote:
> 
> on the journalling side this would be one transaction (not 5 milion)
> and... since inodes are grouped on disk, you can even get some better
> coalescing this way... 
> 
> Wonder if we could do inode-grouping smartly; eg if we HAVE to write
> inode X, also write out the atime-dirty inodes in range X-Y to X+Y
> (where Y is some tunable) in the same IO..

We already have filesystems in the tree that do such advances things as
inode writeback clustering for more than ten years :)
