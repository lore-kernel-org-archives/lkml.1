Return-Path: <linux-kernel-owner+w=401wt.eu-S1756471AbYEaXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbYEaXYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYEaXYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:24:30 -0400
Received: from sous-sol.org ([216.99.217.87]:47528 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbYEaXYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:24:30 -0400
Date: Sat, 31 May 2008 16:24:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Chris Wright <chrisw@sous-sol.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Redzone overwritten with CONFIG_SECURITY
Message-ID: <20080531232352.GV30402@sequoia.sous-sol.org>
References: <20080526143422.GA3203@alice> <84144f020805270800l5911ed02ia7a92d96a8aa32a7@mail.gmail.com> <20080527174738.GZ30402@sequoia.sous-sol.org> <20080528100357.GA2510@alice> <20080528215107.GJ30402@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528215107.GJ30402@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chris Wright (chrisw@sous-sol.org) wrote:
> * Eric Sesterhenn (snakebyte@gmx.de) wrote:
> > Is it possible that this was caused because a file didnt
> > get rebuild correctly? I can still reproduce it with the
> > old checkout. Sorry if this causes unessecary noise :(
> 
> I had wondered that, since data structures will grow w/ CONFIG_SECURITY
> set (like inode, for example).  I haven't encountered a Kbuild dependency
> bug in quite a while though.

Yeah, this thing is miscompiled (thanks for the vmlinux).

$ cd /tmp/CONFIG_SECURITY-mem-corruption
$ gdb -q vmlinux
(gdb) p sizeof(struct inode)
$1 = 596
(gdb) p sizeof(struct hugetlbfs_inode_info)
$2 = 592

struct hugetlbfs_inode_info {
	struct shared_policy policy;
	struct inode vfs_inode;
};
 
The hugetlbfs_inode_info structure isn't updated with the 4 extra bytes
added from CONFIG_SECURITY to struct inode.

If you're interested in more gory details, you can look at:
$ eu-readelf -winfo vmlinux > readelf-info.out

thanks,
-chris
