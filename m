Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbZFQQLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbZFQQLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZFQQK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:10:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbZFQQKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:10:55 -0400
Date: Wed, 17 Jun 2009 09:09:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andreas Dilger <adilger@sun.com>
cc: David Howells <dhowells@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-Reply-To: <20090617075502.GB13073@webber.adilger.int>
Message-ID: <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain>
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Andreas Dilger wrote:
> 
> What about opening the mountpoint (which HAS to be available) and then
> calling an ioctl() on that?

It's very hard to "open the mountpoint" in user space. How would you even 
do it? Remember: we're not living in the 1980's any more, and disco is 
dead. ABBA may have made a comeback, but static mountpoints are long gone, 
and won't be coming back.

These days, you can mount individual files, you can have per-process 
mounts, and automounters have been a fact for a long time. 

So I _agree_ that pioctl's are problematic, but please don't argue against 
them using _stupid_ arguments. And "open the mountpoint" really is a 
stupid argument. It not only isn't possible to do in user space, but you 
may well want to do operations on a particular path, not just the mount.

So you'd need to open the file itself. Which might be a symlink or a 
device node, depending on the exact semantics of pioctl.

We've traditionally had that magic "open with flag=3" to do a magic open 
of device files without waiting, and we have O_NOFOLLOW to open symlinks 
without following them (sadly, it just errors out, rather than opening the 
symlink, but that's another detail). 

So I think it should be solvable some way, but not by trying to find the 
mount point.

			Linus
