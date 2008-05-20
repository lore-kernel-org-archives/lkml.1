Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbYETD5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbYETD5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 23:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbYETD5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 23:57:24 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56087 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYETD5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 23:57:23 -0400
Date: Mon, 19 May 2008 21:57:12 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
In-reply-to: <20080514170625t-sato@mail.jp.nec.com>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <20080520035712.GA7252@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080514170625t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 14, 2008  17:06 +0900, Takashi Sato wrote:
> +static int ioctl_freeze(struct file *filp)
> +{
> +	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	/* If filesystem doesn't support freeze feature, return. */
> +	if (sb->s_op->write_super_lockfs == NULL)
> +		return -EINVAL;

Should this be EINVAL, or EOPNOTSUPP?  Usually EINVAL means there is
something wrong with the passed ioctl parameters (e.g. bad value),
while EOPNOTSUPP is "operation not supported" and makes more sense.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

