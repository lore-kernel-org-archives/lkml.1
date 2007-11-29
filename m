Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXK2WYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXK2WYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761354AbXK2WYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:24:17 -0500
Received: from relay1.sgi.com ([192.48.171.29]:42790 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbXK2WYP (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:24:15 -0500
Date: Fri, 30 Nov 2007 09:24:07 +1100
From: David Chinner <dgc@sgi.com>
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Race between generic_forget_inode() and sync_sb_inodes()?
Message-ID: <20071129222407.GL115527101@sgi.com>
References: <20071129215544.GK115527101@sgi.com> <18255.14346.684631.944181@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18255.14346.684631.944181@notabene.brown>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 09:07:06AM +1100, Neil Brown wrote:
> 
> Hi David,
> 
> On Friday November 30, dgc@sgi.com wrote:
> > 
> > 
> > I came across this because I've been making changes to XFS to avoid the
> > inode hash, and I've found that I need to remove the inode from the
> > dirty list when setting I_WILL_FREE to avoid this race. I can't see
> > how this race is avoided when inodes are hashed, so I'm wondering
> > if we've just been lucky or there's something that I'm missing that
> > means the above does not occur.
> 
> Looking at inode.c in 2.6.23-mm1, in generic_forget_inode, I see code:
> 
> 	if (!hlist_unhashed(&inode->i_hash)) {
> 		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> 			list_move(&inode->i_list, &inode_unused);
> 
> so it looks to me like:
>    If the inode is hashed and dirty, then move it (off the s_dirty
>    list) to inode_unused.

That check is for if the inode is _not_ dirty or being sync, right?
Or have I just not had enough coffee this morning?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
