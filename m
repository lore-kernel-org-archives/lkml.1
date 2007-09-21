Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbXIUOdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbXIUOdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbXIUOdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:33:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbXIUOdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:33:40 -0400
Date: Fri, 21 Sep 2007 15:33:38 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
Message-ID: <20070921143338.GA14577@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org> <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu> <20070921131409.GA9988@infradead.org> <E1IYiOv-0001f6-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IYiOv-0001f6-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 03:18:33PM +0200, Miklos Szeredi wrote:
> > That's something that shouldn't be solved in the filesystem, but rather
> > through exact semantics of unprivilegued mounts.  Given that an
> > unprivilegued implies ignoring the device files we can easily allow
> > users to create them, because they're nothing special anymore.
> 
> Exacly.  And we already have an API for that: mknod(2).  It would be
> quite stupid to introduce _another_ API to do the same.  It would mean
> that all the tools, like mknod(8) would not work with the new API.
> 
> Or am I misunderstanding your suggestion?

Yes :)

My suggestions is:

 - mknod for unprivilegued user is allowed in the following case

    (1) mount point is mounted with MNT_NODEV
    (2) mount point is owner by the user doing mknod

 - and maybe

    (3) we have a special mount option to allow it if we don't want
        to allow it for normal unprivilegued mounts for some reason

which implies we need to get in unprivilegued mounts first, but we'll
have to do that anyway.
