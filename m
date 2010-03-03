Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab0CCOJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:09:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34860 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab0CCOJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:09:45 -0500
Date: Wed, 3 Mar 2010 09:09:41 -0500
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
Message-ID: <20100303140940.GA2253@infradead.org>
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
> I noticed that there are differences in the behavior of listxattr(2) for 
> xattrs in the trusted namespace.
> 
> Some filesystems, such as ext[234], require CAP_SYS_ADMIN for this, i.e. 
> trusted xattr names are hidden from unprivileged users.
> 
> I audited the kernel for users of the trusted xattr namespace, and found 
> the following filesystems not checking for CAP_SYS_ADMIN:
> 
>   - jffs2
>   - ocfs2
>   - btrfs
>   - xfs
> 
> I've created patches for jffs2 (tested) and ocfs2 (not tested) to add the 
> check -- see following emails. btrfs and xfs have custom listxattr 
> operations and will need a bit more work to fix.

I think the behaviour of the above filesystems is correct.  There is no
requirement for privilegues to see the existence of these attributes.
We also don't hide entries that aren't readable from readdir output.

