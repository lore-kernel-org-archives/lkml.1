Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbXDUAIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbXDUAIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 20:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXDUAIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 20:08:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbXDUAIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 20:08:37 -0400
Date: Fri, 20 Apr 2007 17:07:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>, a.righi@cineca.it,
       linux-kernel@vger.kernel.org, reiserfs-dev@namesys.com,
       Edward Shishkin <edward@namesys.com>, zam@clusterfs.com
Subject: Re: Fwd: Fw: [2.6.20.4] BUG: dentry xattrs still in use in
 shrink_dcache_for_umount() with reiserfs
Message-Id: <20070420170738.e269fcae.akpm@linux-foundation.org>
In-Reply-To: <46263270.9010108@suse.com>
References: <20070413095219.02075323.akpm@linux-foundation.org>
	<462536B2.5060308@users.sourceforge.net>
	<c04ebacf0704180152qdc72fcdnd0755dbf070b40d2@mail.gmail.com>
	<200704181816.21166.vs@namesys.com>
	<46263270.9010108@suse.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Apr 2007 11:00:00 -0400
Jeff Mahoney <jeffm@suse.com> wrote:

> > Do you think that could be a reason of the extra reference count on   xattr_root dentry?
> 
> No, I don't think it is. Looking at the code now, it seems obvious, but
> I didn't notice it before and nobody else has reported a problem.
> 
> getxattr() doesn't require any VFS locking. When we get down into the
> reiserfs code, it takes a read lock. If we get two concurrent threads
> looking up an xattr before the root has been saved, there's a window
> where REISERFS_SB(s)->xattr_root is NULL but we've already looked it up
> and taken a reference on it.
> 
> I have a patch set to clean up the extended attribute code that fixes
> this problem along the way by killing off the xattr locks and using the
> backing files/dirs i_mutex instead. I'll post them to the reiserfs
> mailing list.

Do we have anything suitable for 2.6.21 which will address this crash?

Also, it's not clear to me how many users we can expect to be impacted by it.
I assume that if the same bug is in 2.6.20 then the answer is "not many".
How come Andrea is able to keep hitting it?

Thanks.
