Return-Path: <linux-kernel-owner+w=401wt.eu-S1761382AbZATXWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761382AbZATXWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZATXWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:22:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38126 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbZATXWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:22:44 -0500
Date: Tue, 20 Jan 2009 18:22:43 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
       Jacek Luczak <difrost.kernel@gmail.com>,
       Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>,
       xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [PATCH] Re: [XFS] 2.6.29-rc2: XFS internal error
	XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120232242.GA16776@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120133521.GD10158@disturbed> <20090120230306.GE10158@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120230306.GE10158@disturbed>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 10:03:06AM +1100, Dave Chinner wrote:
> [XFS] Long btree pointers are still 64 bit on disk
> 
> On 32 bit machines with CONFIG_LBD=n, XFS reduces the
> in memory size of xfs_fsblock_t to 32 bits so that it
> will fit within 32 bit addressing. However, the disk format
> for long btree pointers are still 64 bits in size.
> 
> The recent btree rewrite failed to take this into account
> when initialising new btree blocks, setting sibling pointers
> to NULL and checking if they are NULL. Hence checking whether
> a 64 bit NULL was the same as a 32 bit NULL was failingi
> resulting in NULL sibling pointers failing to be detected
> correctly. This showed up as WANT_CORRUPTED_GOTO shutdowns
> in xfs_btree_delrec.
> 
> Fix this by making all the comparisons and setting of long
> pointer btree NULL blocks to the disk format, not the
> in memory format. i.e. use NULLDFSBNO.

Thanks, this fixes the testcase for me.
