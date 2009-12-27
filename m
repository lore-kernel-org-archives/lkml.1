Return-Path: <linux-kernel-owner+w=401wt.eu-S1751469AbZL0V1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbZL0V1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbZL0V1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:27:07 -0500
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:42525 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbZL0V1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:27:04 -0500
Date: Mon, 28 Dec 2009 08:27:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: inconsistent lock state
Message-ID: <20091227212700.GA7613@discord.disaster>
References: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0912261255380.3483@bogon.housecafe.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 01:07:49PM -0800, Christian Kujau wrote:
> Hi,
> 
> during tests with bonnie++ on an XFS filesystem, the warning below is 
> issued. From the message's timestamps, the warning occurs during the 
> "Create files in sequential order" phase. I've put a few more details and 
> the config here: http://nerdbynature.de/bits/2.6.33-rc2/xfs_ilock
> 
> Something similar has been reported in http://lkml.org/lkml/2009/2/20/269 
> (for 2.6.29-rc5) and a fix for this false positive made its way into 
> mainline as ed93ec3907f063268ced18728d0653f6199d100c - so I take it this 
> is a different issue then?

This is the usual false positive that is detected - XFS takes locks in
reclaim that it also takes in non-reclaim paths. The reclaim path
from kswapd inverts lock ordering and so we get this report. This
case has never been a deadlock case because an inode in reclaim
cannot be referenced by any other path, so once again it is a
false positive....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
