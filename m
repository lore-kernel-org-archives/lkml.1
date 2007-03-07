Return-Path: <linux-kernel-owner+w=401wt.eu-S965376AbXCGRDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965376AbXCGRDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965398AbXCGRDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:03:46 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43845 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965376AbXCGRDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:03:45 -0500
Date: Wed, 7 Mar 2007 09:02:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
In-Reply-To: <45EE6125.3010702@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703070859070.5963@woody.linux-foundation.org>
References: <45ED1A3C.6030707@argo.co.il> <Pine.LNX.4.64.0703061635430.3661@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703061644570.5963@woody.linux-foundation.org>
 <45EE6125.3010702@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Eric Dumazet wrote:
> 
> I would definitly *love* saving dentries for pipes (and sockets too), but how
> are you going to get the inode ?

Don't use an inode at all.

> pipes()/sockets() can use read()/write()/rw_verify_area() and thus need
> file->f_path.dentry->d_inode (so each pipe needs a separate dentry)

No, at least pipes could easily just use "file->f_private_data" instead.

Now, sockets really do want the inode (or it would be really really big 
changes), but pipes really just want a "struct pipe_inode_info" pointer, 
which we could hide away directly in the file descriptor itself.

That's what Davide already did (on my suggestion) for signalfd - there's a 
*single* inode, and the real data is in the per-fd f_private_data.

		Linus
