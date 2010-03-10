Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab0CJLkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:40:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55403 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0CJLki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:40:38 -0500
Date: Wed, 10 Mar 2010 06:40:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: James Morris <jmorris@namei.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: Re: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted'
	xattrs
Message-ID: <20100310114035.GA32219@infradead.org>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 07:01:05PM +1100, James Morris wrote:
> I audited the kernel for users of the trusted xattr namespace, and found 
> the following filesystems not checking for CAP_SYS_ADMIN:
> 
>   - jffs2
>   - ocfs2
>   - btrfs
>   - xfs

Now that everyone felt the consensus is that we need the check I look
into adding it into XFS, but it seems like we already have that check
in xfs_xattr_put_listent:

	/*
         * Only show root namespace entries if we are actually allowed to
	 * see them.
	 */
	if ((flags & XFS_ATTR_ROOT) && !capable(CAP_SYS_ADMIN))
		return 0;

Can you send me the testcases where XFs shows trusted attributes?

