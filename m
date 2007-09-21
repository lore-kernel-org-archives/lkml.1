Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbXIUNK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbXIUNK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbXIUNKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:10:46 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:52644 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974AbXIUNKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:10:44 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921124504.GC8088@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 13:45:04 +0100)
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org>
Message-Id: <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 15:10:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a new filesystem flag, that results in the VFS not checking if the
> > current process has enough privileges to do an mknod().
> > 
> > This is needed on filesystems, where an unprivileged user may be able
> > to create a device node, without causing security problems.
> 
> A user should never be able to create devices.

A user can already create a device with fuse implicitly.  This patch
would just allow that explicitly.

Take this example: I've loopback mounted an UML disk image using fuse
(no privileges required), and want to create some device nodes.  I
can't yet boot the UML because the device node is missing from the
image.  So what should I do.  Currently I have to manipulate the
mounted image as root.  But that's really shouldn't be needed.

> And no, I don't want to see a filesystem that implements it's own
> file operations for device nodes.

I don't want that either, and it has nothing to do with this patch.

Miklos
