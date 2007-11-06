Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXKFFQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXKFFQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbXKFFQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:16:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbXKFFQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:16:11 -0500
Date: Tue, 6 Nov 2007 00:15:32 -0500
From: Alexander Viro <aviro@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve Dickson <SteveD@redhat.com>, Alexander Viro <aviro@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [PATCH] NFS: Stop sillyname renames and unmounts from racing
Message-ID: <20071106051532.GA5397@devserv.devel.redhat.com>
References: <472C56E5.1040901@RedHat.com> <20071105210636.2fc72e14.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105210636.2fc72e14.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 09:06:36PM -0800, Andrew Morton wrote:
> > Any objections to exporting the inode_lock spin lock?
> > If so, how should modules _safely_ access the s_inode list?

> That's going to make hch unhappy.

That's going to make me just as unhappy, especially since it's pointless;
instead of the entire sorry mess we should just bump sb->s_active to pin
the superblock down (we know that it's active at that point, so it's just
an atomic_inc(); no games with locking, etc., are needed) and call
deactivate_super() on the way out.  And deactivate_super() is exported
already.
