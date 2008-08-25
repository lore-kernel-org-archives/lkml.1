Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbYHYQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbYHYQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYHYQQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 12:16:16 -0400
Received: from mail.fieldses.org ([66.93.2.214]:47165 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbYHYQQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 12:16:16 -0400
Date: Mon, 25 Aug 2008 12:16:05 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Harkes <jaharkes@cs.cmu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] readdir mess
Message-ID: <20080825161605.GI30871@fieldses.org>
References: <alpine.LFD.1.10.0808121009370.3462@nehalem.linux-foundation.org> <20080812181057.GR28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121316570.3462@nehalem.linux-foundation.org> <20080812203808.GV28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0808121351570.3462@nehalem.linux-foundation.org> <20080813000433.GZ28946@ZenIV.linux.org.uk> <20080815050613.GJ4422@cs.cmu.edu> <alpine.LFD.1.10.0808150940110.3324@nehalem.linux-foundation.org> <20080824101014.GN28946@ZenIV.linux.org.uk> <20080824110326.GO28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080824110326.GO28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 12:03:26PM +0100, Al Viro wrote:
> On Sun, Aug 24, 2008 at 11:10:14AM +0100, Al Viro wrote:
> 
> > I agree that such transition plan makes sense, but that'll take more
> > preliminary work than in your patch; there are other vfs_readdir() and
> > ->readdir() callers, not just the obvious syscall ones.
> 
> BTW, nfsd4_list_rec_dir() is FUBAR.  Its users, actually - they try to use it
> for lovely things like kernel-side rm -rf /var/lib/nfs/v4recovery/* and
> screw up in rather amusing ways..  I'm not even talking about the effects
> of OOM (dentry leak); if you rename something away from that directory,
> you'll get vfs_rmdir(dir, dentry) with dentry not being a child of dir,
> which means deadlock if you are lucky and underlying fs corruption if you
> are not...
> 
> I really wonder WTF is that doing in the kernel, anyway.  Looks like an
> obvious candidate for userland helper...

Yes.  Christoph complained about this before (err, 3 years ago!), though
without (as far as I can tell) catching those particular bugs:

	http://marc.info/?l=linux-fsdevel&m=112703894118581&w=2

We eventually agreed that it was a problem and worked on a userspace
replacement, but it never got to the point where I was happy enough with
it to commit to the new user interface, and the effort died.  I'll take
a look at what we last had.

--b.
