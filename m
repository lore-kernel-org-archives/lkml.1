Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbYFWOuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbYFWOuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbYFWOuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:50:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:56762 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbYFWOuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:50:19 -0400
From: Andreas Gruenbacher <agruen@suse.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 3/3] vfs: make d_path() consistent across mount operations
Date: Mon, 23 Jun 2008 16:50:16 +0200
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Christoph Hellwig <hch@infradead.org>
References: <20080616112804.930095761@szeredi.hu> <20080616112830.003942737@szeredi.hu> <20080623140144.GX28946@ZenIV.linux.org.uk>
In-Reply-To: <20080623140144.GX28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231650.16692.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 16:01:44 Al Viro wrote:
> Umm...  I don't see problems with doing that, but I hope you realize that
> the notion of "ever having that name" is not the same as "pathnam
> resolution on that name ever leading to that file" - path_walk() is *NOT*
> atomic wrt rename() (or mount --move, indeed) and it's quite possible to
> walk into subdirectory, have it moved under you, then see .. as the next
> pathname component and step out into new parent.

Yes, that's understood. Relative lookups don't visit all 
directories up to the root (unless via ".."), so there can be 
infinite time between walking down a directory and computing 
a pathname for it.

> Said that, it makes sense to avoid dropping/regaining the lock in that
> case - it's less work and I don't believe that it would increase contention
> on vfsmount_lock.  So I'm applying that one, just be careful with
> assumptions about consistency, etc. in the general area.

Thanks.

Andreas
