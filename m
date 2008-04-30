Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYD3GgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYD3GgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYD3GgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:36:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56385 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754950AbYD3GgH (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:36:07 -0400
Date: Wed, 30 Apr 2008 16:35:44 +1000
From: David Chinner <dgc@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <dgc@sgi.com>, linux-next@vger.kernel.org,
       xfs-masters@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
       Lachlan McIlroy <lachlan@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: xfs build failure
Message-ID: <20080430063544.GA108924158@sgi.com>
References: <20080430140027.6cd83fd0.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430140027.6cd83fd0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 02:00:27PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc ppc64_defconfig) fails like this:
> 
> fs/xfs/xfs_ialloc.c: In function 'xfs_ialloc_ag_alloc':
> fs/xfs/xfs_ialloc.c:301: error: implicit declaration of function 'random32'
> 
> I added
> 
> #include <linux/random.h>
> 
> after the other includes in fs/xfs/xfs_ialloc.c, but there is probably a
> better fix.
> 
> The commit that seems to have caused this
> 6309a0720469beb77e0ab75f403a98a0aba4140c ("XFS] Don't initialise new
> inode generation numbers to zero") in the xfs tree that I have seems to
> have just gone into Linus' tree as commit
> 359346a9655c8800408ed3ca44517ac7ea95c197.

Ah, I see the problem - a CONFIG_XFS_DEBUG build includes linux/random.h
in a debug header file. That's probably why I didn't catch it (I need to
check the .config on my build test tree).

I'll get it fixed properly, but in the mean time the include you've got
there will suffice...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
