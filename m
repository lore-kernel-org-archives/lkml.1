Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbZIYMSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbZIYMSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 08:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZIYMSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 08:18:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51225 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZIYMSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 08:18:16 -0400
To: "Dr. David Alan Gilbert" <linux@treblig.org>
CC: miklos@szeredi.hu, agruen@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090925123747.GA31228@gallifrey> (linux@treblig.org)
Subject: Re: [PATCH] vfs: new O_NODE open flag
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey>
Message-Id: <E1Mr9ke-0005uJ-KD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Sep 2009 14:18:16 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009, Dr. David Alan Gilbert wrote:
> * Miklos Szeredi (miklos@szeredi.hu) wrote:
> > On Fri, 25 Sep 2009, Andreas Gruenbacher wrote:
> > > On Thursday, 24 September 2009 16:51:58 Miklos Szeredi wrote:
> > > > This patch adds a new open flag, O_NODE.  This flag means: open just
> > > > the filesystem node instead of the object referenced by the node.
> > > 
> > > What is the intended use for O_NODE?
> > 
> > It lets userspace file descriptors reference a inode without actually
> > "dereferencing" it to get the underlying object.  This allows for a
> > couple of new things:
> > 
> >  - opening a special file (device/socket/fifo) without side effects
> > 
> >  - opening a symlink
> > 
> >  - opening any type of file without any permission is also possible
> >    (of course the resuling file descriptor may not be read or written)
> > 
> > The above allows fstat(), fchmod(), ioctl(), etc to be used for files
> > previously not possible.
> 
> Given an fd opened in this way is it possible to reopen it normally and
> be guarenteed to get the same object?

For directories it should be possible with:

  fd = open(path, O_NOACCESS | O_NODE);
  fd2 = openat(fd, ".", O_RDWR);

We could implement something similar for non-directories as well, by
treating a NULL path parameter to openat() to mean - reopen:

  fd2 = openat(fd, NULL, O_RDWR);

Comments?

Thanks,
Miklos
