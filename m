Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYH1Nx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYH1Nx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYH1NxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:53:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYH1NxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:53:18 -0400
Date: Thu, 28 Aug 2008 09:52:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Osterlund <petero2@telia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       viro@zeniv.linux.org.uk
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
Message-ID: <20080828135245.GA12410@infradead.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <alpine.LFD.1.10.0808241120460.3363@nehalem.linux-foundation.org> <m3k5e2qkk2.fsf@telia.com> <alpine.LFD.1.10.0808271335260.3363@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808271335260.3363@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 01:40:10PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 27 Aug 2008, Peter Osterlund wrote:
> > 
> > Why not just revert the offending change and try again during the next
> > merge window, assuming someone has figured out an acceptable way to
> > handle this mess by then?
> 
> Well,, for 2.6.27 that's what we'll have to do. But there's actually a 
> real problem here - the unlocked ioctl's (which we _should_ prefer) have a 
> strictly weaker and worse interface. I also wonder if any other 
> block_ioctl users were converted..

Actually both interfaces are a fscking disaster.  The right things to
pass is neither and inode nor a file but a struct block_device.  Al had
all this work done a while and it just needs rebasing to a current tree:

	http://git.kernel.org/?p=linux/kernel/git/viro/bdev.git;a=summary
