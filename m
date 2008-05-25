Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbYEYTXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbYEYTXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757474AbYEYTXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:23:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57643 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227AbYEYTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:23:08 -0400
Date: Sun, 25 May 2008 15:23:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, swhiteho@redhat.com
Subject: Re: [patch 04/14] gfs2: dont call permission()
Message-ID: <20080525192307.GA1949@infradead.org>
References: <20080521171458.077908538@szeredi.hu> <20080521171546.697638614@szeredi.hu> <20080523091805.GB27119@infradead.org> <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JzTsy-0001b8-Cr@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2008 at 11:48:28AM +0200, Miklos Szeredi wrote:
> > Bad idea.  You're duplicating bits out of permission for no good
> > reason.  I spent quite a bit of effort to make sure we don't have
> > this duplicated logic around.
> 
> In this case you are wrong.  Look at the ugly conditional locking
> gfs2_permission() does, which is probably due to the fact that it's
> doing a recursion via calling permission() from inside already locked
> parts in the filesystem.

The conditional locking will have to stay anyway until the NFS issues
are sorted out.  And as Steve mention I'd rather eventually sort out
the need why gfs2 needs these permission/foo_permission calls at all.

Currently out VFS support for clustered filesystem sucks quite badly,
and we need some way to allow callouts into cluster locks around the
whole namespace operation so we can rely on a single permission check.

That beeing said once the nfs issues are sorted out you patch might
not be too bad it it kills all remaining recursive locking in gfs.

But that's left up to Steve to decide.

