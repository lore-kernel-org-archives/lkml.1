Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXHEUgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXHEUgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXHEUgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:36:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34683 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbXHEUgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:36:14 -0400
Date: Sun, 5 Aug 2007 21:36:02 +0100
From: Christoph Hellwig <hch@infradead.org>
To: J??rn Engel <joern@logfs.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805203602.GB25107@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	J??rn Engel <joern@logfs.org>, Ingo Molnar <mingo@elte.hu>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk, david@lang.hm
References: <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org> <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org> <20070804192130.GA25346@elte.hu> <20070804192615.GA25600@lazybastard.org> <20070804194259.GA25753@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804194259.GA25753@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 09:42:59PM +0200, J??rn Engel wrote:
> On Sat, 4 August 2007 21:26:15 +0200, J??rn Engel wrote:
> > 
> > Given the choice between only "atime" and "noatime" I'd agree with you.
> > Heck, I use it myself.  But "relatime" seems to combine the best of both
> > worlds.  It currently just suffers from mount not supporting it in any
> > relevant distro.
> 
> And here is a completely untested patch to enable it by default.  Ingo,
> can you see how good this fares compared to "atime" and
> "noatime,nodiratime"?

Umm, no f**king way.  atime selection is 100% policy and belongs into
userspace.  Add to that the problem that we can't actually re-enable
atimes because of the way the vfs-level mount flags API is designed.
Instead of doing such a fugly kernel patch just talk to the handfull
of distributions that matter to update their defaults.

