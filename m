Return-Path: <linux-kernel-owner+w=401wt.eu-S1759714AbYEMIei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714AbYEMIei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbYEMIeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:34:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60155 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759525AbYEMIeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:34:20 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080509194642.GA783@infradead.org> (message from Christoph
	Hellwig on Fri, 9 May 2008 15:46:42 -0400)
Subject: Re: [patch 6/9] fuse: add export operations
References: <20080509124107.645600519@szeredi.hu> <20080509124133.577558326@szeredi.hu> <20080509194030.GA29118@infradead.org> <20080509194642.GA783@infradead.org>
Message-Id: <E1Jvpxc-0000Tx-JU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 13 May 2008 10:34:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, May 09, 2008 at 03:40:30PM -0400, Christoph Hellwig wrote:
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
> 
> Actually that patch should be ready for submission, so if you want to
> use it (and it should help cleaning things up a bit) feel free to add
> it to the series.  I'll provide a proper description and sign-off in
> that case.

Yeah, it would help.

One suggestion I have for that patch: leave export_encode_fh() as is
(or just rename got generic_encode_fh()), and introduce a new
generic_encode64_fh().  One less magic boolean parameter to worry
about, and there's very little shared code between those two anyway.

Miklos
