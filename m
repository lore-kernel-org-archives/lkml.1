Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbZI1QER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbZI1QER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZI1QEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:04:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47825 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbZI1QEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:04:16 -0400
To: Andreas Dilger <adilger@sun.com>
CC: miklos@szeredi.hu, Valdis.Kletnieks@vt.edu, linux@treblig.org,
       agruen@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090928152128.GA3384@webber.adilger.int> (message from Andreas
	Dilger on Mon, 28 Sep 2009 09:21:28 -0600)
Subject: Re: [PATCH] vfs: new O_NODE open flag
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
 <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
 <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu>
 <20090925183523.GA6065@gallifrey> <19645.1253913514@turing-police.cc.vt.edu>
 <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu> <20090928152128.GA3384@webber.adilger.int>
Message-Id: <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 28 Sep 2009 18:04:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009, Andreas Dilger wrote:
> On Sep 28, 2009  12:25 +0200, Miklos Szeredi wrote:
> > BTW I just checked, and it is possible to re-open or promote an fd
> > opened with O_NODE like this:
> > 
> > 	char tmp[64];
> > 
> > 	fd = open(filename, O_NODE | O_NOACCESS);
> > 	/* ... */
> > 	sprintf(tmp, "/proc/self/fd/%i", fd);
> > 	fd_rw = open(tmp, O_RDWR);
> > 
> > Now fd_rw is guaranteed to refer to the same inode as fd.
> 
> It seems very unpleasant to require applications using O_NODE to
> reopen files using /proc.

The point of the above example was that reopening a file descriptor
with upgraded (or downgraded) access mode is even now possible.  Which
either means:

 a) the current permission model under /proc/PID/fd has a security
    hole (which Jamie is worried about)

 b) we can safely implement this with by changing openat() semantics,
    or even with a new reopen() syscall

I'm not too worried about the security aspect of this, but it's
something to keep in mind.

Thanks,
Miklos
