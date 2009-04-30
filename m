Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZD3Tn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZD3Tn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZD3Tnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:43:49 -0400
Received: from thunk.org ([69.25.196.29]:54841 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZD3Tns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:43:48 -0400
Date: Thu, 30 Apr 2009 15:43:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/2] A new way of attaching information to inodes
Message-ID: <20090430194339.GE19276@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
References: <1241112678-6615-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241112678-6615-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 07:31:16PM +0200, Jan Kara wrote:
> 
>   currently our VFS inode structure is quite big. It contains quite some
> members that are useful only in some cases (e.g. device pointers and list head
> used only when the inode represents a block/character device, quota pointers
> used only when the filesystem actually supports quota, etc.). And it would
> be helpful to add some more so that we can handle ACL's in generic code, or
> we can do some kind of block reservation for mmaped writes, and there are
> other cases.

One of the things on my "round tuit" list was separating out those
inode fields which are only needed when the inode is in use, and
separating them out into a separate data structure, so that the 90+%
of the inodes which are just being cached, and are not active, don't
burn space in struct inode.  In particular, we can probably move out
i_mutex, i_alloc_sem, i_size_seqcount, i_flock, and perhaps others.

The same applies for the filesystem-specific portion of the in-core
inode; and for some filesystems there might be even more opportunity
for savings there.

Just a thought,

						- Ted
