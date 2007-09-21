Return-Path: <linux-kernel-owner+w=401wt.eu-S1758868AbXIUNS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758868AbXIUNS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbXIUNSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:18:51 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:40645 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbXIUNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:18:50 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921131409.GA9988@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 14:14:09 +0100)
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org> <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu> <20070921131409.GA9988@infradead.org>
Message-Id: <E1IYiOv-0001f6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 15:18:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Take this example: I've loopback mounted an UML disk image using fuse
> > (no privileges required), and want to create some device nodes.  I
> > can't yet boot the UML because the device node is missing from the
> > image.  So what should I do.  Currently I have to manipulate the
> > mounted image as root.  But that's really shouldn't be needed.
> 
> That's something that shouldn't be solved in the filesystem, but rather
> through exact semantics of unprivilegued mounts.  Given that an
> unprivilegued implies ignoring the device files we can easily allow
> users to create them, because they're nothing special anymore.

Exacly.  And we already have an API for that: mknod(2).  It would be
quite stupid to introduce _another_ API to do the same.  It would mean
that all the tools, like mknod(8) would not work with the new API.

Or am I misunderstanding your suggestion?

Miklos
