Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXKFIvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXKFIvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXKFIvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:51:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466AbXKFIvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:51:00 -0500
Date: Tue, 6 Nov 2007 03:50:26 -0500
From: Alexander Viro <aviro@redhat.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steve Dickson <SteveD@redhat.com>, Alexander Viro <aviro@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH] NFS: Stop sillyname renames and unmounts from racing
Message-ID: <20071106085026.GB5397@devserv.devel.redhat.com>
References: <472C56E5.1040901@RedHat.com> <20071105210636.2fc72e14.akpm@linux-foundation.org> <473024D2.6080105@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473024D2.6080105@panasas.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:24:50AM +0200, Benny Halevy wrote:

> It'd be very nice if the silly renamed inodes (with silly_count > 1) were moved
> to a different list in the first pass, under the inode_lock, and then waited on
> until silly_count <= 1 in a second pass only on the filtered list.  This will
> provide you with O(1).

It's absolutely pointless, starting with any kind of searching for inodes,
etc.  If you want fs shutdown _not_ to happen until async activity of
that kind is over, don't reinvent the sodding wheels, just tell VFS that
you are holding an active reference to superblock.  End of story.
