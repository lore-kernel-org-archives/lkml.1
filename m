Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbYEONHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbYEONHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYEONHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:07:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41459 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYEONHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:07:10 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080509194642.GA783@infradead.org> (message from Christoph
	Hellwig on Fri, 9 May 2008 15:46:42 -0400)
Subject: Re: [patch 6/9] fuse: add export operations
References: <20080509124107.645600519@szeredi.hu> <20080509124133.577558326@szeredi.hu> <20080509194030.GA29118@infradead.org> <20080509194642.GA783@infradead.org>
Message-Id: <E1JwdAj-0006ix-QP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 May 2008 15:07:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is the same filehandle type XFS uses for 64bit inode filesystems
> > where the parent is not encoded.  I'll post a patch soon to move that
> > 64bit inode handling to common code.  I don't think it's a good idea
> > to delay your patch until that happens, but can you chose the fid
> > types to be the same as XFS does currently so that a conversion is
> > easily possible.  The fh_type should be 0x81 (fh type 1 order by 0x80
> > to imply it's 64bit inodes)
> > 
> > In case you want to look at that patch I'v uploaded the current
> > version at http://verein.lst.de/~hch/generic-64bit-inode-export

OK, the problem is: fuse doesn't store the number indexing the inodes
in i_ino.  This is not entirely trivial to fix: we either supply the
inode numbers to the encoding function explicitly, or use something
like the get_inode callback in generic_fh_to_dentry/_parent.  At which
point I begin to doubt if it's worth the effort to share this code.
After all the encoding/decoding functions are not complicated at all.

Miklos
