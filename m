Return-Path: <linux-kernel-owner+w=401wt.eu-S966637AbZLHWGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966637AbZLHWGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966598AbZLHWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 17:06:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966623AbZLHWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 17:06:33 -0500
Date: Tue, 8 Dec 2009 22:06:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: hugh.dickins@tiscali.co.uk, viro@ftp.linux.org.uk,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
Message-ID: <20091208220638.GN14381@ZenIV.linux.org.uk>
References: <20091208060701.GM14381@ZenIV.linux.org.uk> <Pine.LNX.4.64.0912081142280.31223@sister.anvils> <Pine.LNX.4.64.0912081254500.3365@sister.anvils> <20091208.130802.25121122.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208.130802.25121122.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 01:08:02PM -0800, David Miller wrote:
> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Date: Tue, 8 Dec 2009 13:03:30 +0000 (GMT)
> 
> > That would impose some (unacceptable?) limits, and require some funny
> > code to migrate the pages over to the new mm later (instead of
> > relocating within the new mm as we do now).
> 
> I think this approach would create new failure cases that don't exist
> now.  Whether that's acceptable or not is another issue.
> 
> The forced page table move, and TLB+cache flush that goes along with
> that, for every single compat task we get now on the other hand is not
> acceptable :-)
> 
> I also think this page table move overhead is worse than the
> non-swapability added by Al's approach.

We should be able to make them swappable - embed an inode into bprm, use
a _very_ trimmed-down analog of shmem.c to handle it, then, after switch
to new VM, swap what's needed in, steal it from that inode and shove resulting
anon pages into freshly created stack vma.  At least assuming that I haven't
completely misunderstood Rik's answers to my questions, which is admittedly
quite possible ;-)

I'll try to do it that way and see what falls out...
