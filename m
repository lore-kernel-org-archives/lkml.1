Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbYGRV6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbYGRV6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGRV61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:58:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57418 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYGRV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:58:26 -0400
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: jfs-discussion@lists.sourceforge.net,
       Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807181108r53ea74adsd471e49f87d77024@mail.gmail.com>
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
	 <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
	 <1216402157.11215.21.camel@norville.austin.ibm.com>
	 <19f34abd0807181108r53ea74adsd471e49f87d77024@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 16:58:22 -0500
Message-Id: <1216418302.30152.6.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 20:08 +0200, Vegard Nossum wrote:
> On Fri, Jul 18, 2008 at 7:29 PM, Dave Kleikamp
> <shaggy@linux.vnet.ibm.com> wrote:
> >
> > xtTruncate can call release_metapage() in several places.  If you still
> > have this kernel, could you please run addr2line against c02e4202?  If
> > you've rebuilt your kernel since then, I understand.
> 
> Sorry, it's gone. However, I just recompiled it and the size of the
> function is now 0x105f, and the offset 0xd42 matches with a call to
> release_metapage. So with this new address, it's this call:
> 
> $ addr2line -e vmlinux -i c02e428d
> fs/jfs/jfs_metapage.h:101
> fs/jfs/jfs_xtree.c:3723
> 
> ...which is this one:
> 
>     /* invalidate empty leaf page */
>     discard_metapage(mp);

Thanks.  This helps some, but I'm not sure why it should fail there.
Possibly a memory corruption problem caused by a bug in an earlier error
path.

> With your two patches applied, I now got this:
> 
> ERROR: (device loop0): remounting filesystem as read-only
> blkno = 200000687, nblocks = f
> ERROR: (device loop0): dbFree: block to be freed is outside the map
> BUG: unable to handle kernel paging request at 338f8038

I see I've got a few of these to track down.  I'm sure there are more
than a couple more bugs you will uncover.

> $ addr2line -e vmlinux -i c02ee352
> fs/jfs/jfs_dmap.c:2188
> 
> You can also have a copy of my scripts if you want to try to reproduce
> it locally. But I don't mind testing either :-)

Can you please send me a copy.  For some of these, I'd like to get a
repeatable test case, so I'm not debugging several problems at once.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

