Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZADPeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZADPeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZADPeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:34:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36708 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZADPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:34:08 -0500
Date: Sun, 4 Jan 2009 10:34:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
       Adam Nielsen <a.nielsen@shikadi.net>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: XFS internal error xfs_da_do_buf(1) at line 2015 of file
	fs/xfs/xfs_da_btree.c
Message-ID: <20090104153401.GA16185@infradead.org>
References: <49600DE6.2080108@shikadi.net> <20090104074659.GA16775@infradead.org> <49607B5B.3070707@shikadi.net> <20090104092349.GA26194@infradead.org> <20090104114425.241f6630@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104114425.241f6630@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 11:44:25AM +0000, Alan Cox wrote:
> Generally they avoid setting -W0 because it ruins performance and can be
> very bad for disk lifetime. The barriers code is there for a reason.

We've done measurements and for modern NCQ/TCQ disks the performance
for cache off vs cache on + barriers is close.  For ext3 barriers is
generally slightly faster, and for XFS it's even or sometimes even cache
off is faster depending on the workload.

> Of course certain distributions default to using LVM for all their file
> systems which is completely and mindbogglingly bogus. That both messes up
> barriers in some cases and takes a good 10-20% off performance when I've
> benched it.

The thing is that there's no reason for that at all with just a single
underlying disk.  There is absolutely no reason for not passing through
barriers, and there's also no reason why it should be any slower than
our most trivially volume manager, the partition remapping code.  In
fact there's no reason trivial device mapper tables couldn't be handled
by the partition remapping code..

