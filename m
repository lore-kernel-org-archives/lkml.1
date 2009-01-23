Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbZAWFvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbZAWFvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbZAWFvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:51:14 -0500
Received: from eazy.amigager.de ([213.239.192.238]:35417 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZAWFvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:51:13 -0500
Date: Fri, 23 Jan 2009 06:51:09 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lars Noschinski <lkml@ml.noschinski.de>, linux-kernel@vger.kernel.org
Subject: Re: XFS error & call trace
Message-ID: <20090123055109.GA25601@x61>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Lars Noschinski <lkml@ml.noschinski.de>,
	linux-kernel@vger.kernel.org
References: <20090121222703.GA5522@aprove.informatik.rwth-aachen.de> <20090121231435.GA6810@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121231435.GA6810@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 18:14:35 -0500, Christoph Hellwig wrote:
> On Wed, Jan 21, 2009 at 11:27:03PM +0100, Lars Noschinski wrote:
> > Hello!
> > 
> > I just had a crash of my XFS file system on 2.6.29-rc1 (syslog output
> > follows) After this, the file system on /home returned -EIO on most (all?)
> > operations.  After a reboot from cdrom, I found it interesting to see that
> > xfs_check found no error on this partition. Instead, the XFS on the /
> > partition had a lot of errors.
> 
> The patch below from Dave Chinner fixes it:
> 
> ---
> 
> [XFS] Long btree pointers are still 64 bit on disk
> 
> On 32 bit machines with CONFIG_LBD=n, XFS reduces the
> in memory size of xfs_fsblock_t to 32 bits so that it
> will fit within 32 bit addressing. However, the disk format
> for long btree pointers are still 64 bits in size.
> 
> The recent btree rewrite failed to take this into account

Hi,

does this commit also fix http://lkml.org/lkml/2009/1/7/324 ?

Regards,
Tino
