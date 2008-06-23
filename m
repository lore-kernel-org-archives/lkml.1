Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYFWUbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYFWUbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYFWUbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:31:44 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:57878 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbYFWUbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:31:42 -0400
Date: Mon, 23 Jun 2008 14:31:07 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] extX: convert prink(KERN_WARNING) to extX_warning()
In-reply-to: <20080622201841.669ff882@olorin>
To: FD Cami <francois.cami@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>
Message-id: <20080623203107.GD6239@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080622201841.669ff882@olorin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22, 2008  20:18 +0200, FD Cami wrote:
> This patch takes a shot at replacing the direct use of printk(KERN_WARNING)
> in extX by extX_warning. We now get the device number in the warning message :
> "EXT3-fs warning (device hda1): ext3_setup_super: maximal mount count reached, running e2fsck is recommended"
> It also adds the device information on a pair of printk(KERN_ERR) (this was
> first suggested by Kasper two weeks ago).

The one issue is that KERN_ERR != KERN_WARNING, so these errors might
not be visible on the console, or may not be saved to the syslog.  The
other minor difference is that the function name is also printed, and this
makes the error message very long.

One suggestion is to create a separate macro that passes the KERN_*
flag and __func__ to ext3_console_msg(), and call that from
ext3_warning() and a new ext3_start_error() function.  I always found
it annoying to have to specify __func__ as a parameter for every call.

>  	ext3_warning(sb, __func__,
> -		     "updating to rev %d because of new feature flag, "
> -		     "running e2fsck is recommended",
> -		     EXT3_DYNAMIC_REV);
> +			"updating to rev %d because of new feature flag, "
> +			"running e2fsck is recommended",
> +			EXT3_DYNAMIC_REV);

Please don't change all of the indenting.  The old indending is proper
linux coding style (aligned with previous '('), the new one is not.

Note that you need to split up the patches for ext2, ext3, ext4 into
separate emails.  I'd suggest just sending one of them until we agree
on what is right, then submitting the rest afterward.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

