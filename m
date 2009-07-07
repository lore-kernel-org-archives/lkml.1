Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZGGN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZGGN5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZGGN5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:57:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524AbZGGN5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:57:09 -0400
Date: Tue, 7 Jul 2009 09:57:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20090707135706.GB4997@infradead.org>
References: <20090707134908.e81b1556.sfr@canb.auug.org.au> <20090707063846.GY23611@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090707063846.GY23611@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 08:38:46AM +0200, Jens Axboe wrote:
> >  SYSCALL_DEFINE0(sync)
> >  {
> > -	wakeup_pdflush(0);
> > +	wakeup_flusher_threads(0);
> >  	sync_filesystems(0);
> >  	sync_filesystems(1);
> >  	if (unlikely(laptop_mode))
> 
> That is correct! I have just now updated for-next as well, so your next
> pull should lose this fixup.

It's not correct at all.  We'll how have various flusher threads doing
async syncs, just to wait for them again synchronously.  The right thing
to do here is to queue up the data integrity sync to per-bdi threads and
execute those in parallel.

