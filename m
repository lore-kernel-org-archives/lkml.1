Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbZHGUQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbZHGUQC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbZHGUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:16:01 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39832 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933596AbZHGUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:16:00 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Fri, 07 Aug 2009 14:14:47 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 3/4] vfs: change sb->s_maxbytes to a loff_t
In-reply-to: <1249671461-9071-4-git-send-email-jlayton@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Message-id: <20090807201447.GQ3340@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
 <1249671461-9071-4-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 07, 2009  14:57 -0400, Jeff Layton wrote:
> +	/*
> +	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
> +	 * but s_maxbytes was an unsigned long long for many releases. Throw
> +	 * this warning for a little while to try and catch filesystems that
> +	 * violate this rule. This warning can be removed in 2.6.34.
> +	 */
> +	WARN(((unsigned long long) mnt->mnt_sb->s_maxbytes > MAX_LFS_FILESIZE),
> +		"WARNING: %s sets sb->s_maxbytes too large (%llu)", type->name,
> +		(unsigned long long) mnt->mnt_sb->s_maxbytes);

Rather than removing this check, it should be changed into a BUG_ON() so
that no filesystems are added/modified to get it wrong.  We hit this
problem once in the past also...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

