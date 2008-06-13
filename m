Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbYFMPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbYFMPgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 11:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbYFMPgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 11:36:07 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:53708 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178AbYFMPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 11:36:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGcuUkh5LG+u/2dsb2JhbACuHg
X-IronPort-AV: E=Sophos;i="4.27,639,1204464600"; 
   d="scan'208";a="125702030"
Date: Sat, 14 Jun 2008 01:36:01 +1000
From: Dave Chinner <david@fromorbit.com>
To: Miquel van Smoorenburg <mikevs@xs4all.net>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: [xfs-masters] Re: XFS internal error xfs_trans_cancel at line
	1163 of file fs/xfs/xfs_trans.c
Message-ID: <20080613153601.GF3700@disturbed>
Mail-Followup-To: Miquel van Smoorenburg <mikevs@xs4all.net>,
	Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
	xfs-masters@oss.sgi.com
References: <20080612123031.21594jyk6rjc1lfk@imp.ku-gbr.de> <6101e8c40806120733m3c8647ccy149eb237e2c6d027@mail.gmail.com> <1213309629.29745.8.camel@localhost.localdomain> <20080613030841.GC3700@disturbed> <20080613072405.GA3474@anita>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613072405.GA3474@anita>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 09:24:05AM +0200, Konstantin Kletschke wrote:
> Am 2008-06-13 13:08 +1000 schrieb Dave Chinner:
> 
> > This commit in 2.6.26 will probably fix it.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75de2a91c98a6f486f261c1367fe59f5583e15a3
> 
> Well, the description points out solving issues regarding dealing with
> ENOSPC shutting the fs not down when it is not really necessary. Does
> this count here, where my fs is 
> /dev/sda7             120G   12G  108G  10% /home
> with inode usage of
> /dev/sda7            125001728 1310022 123691706    2% /home

Perhaps you've fragmented free space, which can lead to this
problem. Inodes require contiguous free space to be allocated.

Please search the mail list archive for this error to find more
about triaging the cause (i.e. the thread that led up to finding
the above problem).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
