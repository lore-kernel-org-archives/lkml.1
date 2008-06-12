Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYFLJGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYFLJGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYFLJGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:06:35 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51934 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbYFLJGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:06:34 -0400
Date: Thu, 12 Jun 2008 03:06:29 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 4/6] ext2: tighten restrictions on inode flags
In-reply-to: <1213142649-32685-5-git-send-email-duaneg@dghda.com>
To: Duane Griffin <duaneg@dghda.com>
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <20080612090629.GX3726@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 11, 2008  01:04 +0100, Duane Griffin wrote:
> At the moment there are few restrictions on which flags may be set on which
> inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
> and APPEND may not be set on links. Tighten that to disallow TOPDIR being
> set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
> NOCOMP, ECOMPR, INDEX, JOURNAL_DATA and NOTAIL being set on anything but
> regular files or directories.
> 
> Introduce a flags masking function which masks flags based on mode and use
> it during inode creation and when flags are set via the ioctl to facilitate
> future consistency.

This second set of patches is missing out on the presence of the
"EXT2_FL_USER_MODIFIABLE" mask in ext2_ioctl(EXT2_IOC_SETFLAGS).  This is
what prevents "unsettable" flags from being set from userspace.

I don't have any objection to additional filtering to avoid setting the
USER_MODIFIABLE flags on special files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

