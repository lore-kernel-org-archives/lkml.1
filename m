Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab0BJIlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:41:06 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44564 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0BJIlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:41:05 -0500
To: Goswin von Brederlow <goswin-v-b@web.de>
CC: tj@kernel.org, fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org, mszeredi@suse.cz,
       linux-kernel@vger.kernel.org
In-reply-to: <87k4ulo5w2.fsf@frosties.localdomain> (message from Goswin von
	Brederlow on Wed, 10 Feb 2010 09:24:13 +0100)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <87k4ulo5w2.fsf@frosties.localdomain>
Message-Id: <E1Nf87U-0000QD-7V@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 10 Feb 2010 09:40:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Goswin von Brederlow wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > Implement FUSE direct mmap support.  The server can redirect client
> > mmap requests to any SHMLBA aligned offset in the custom address space
> > attached to the fuse channel.  The address space is managed by the
> > server using mmap/munmap(2).  The SHMLBA alignment requirement is
> > necessary to avoid cache aliasing issues on archs with virtually
> > indexed caches as FUSE direct mmaps are basically shared memory
> > between clients and the server.
> >
> > The direct mmap address space is backed by pinned kernel pages which
> > are allocated on the first fault either from a client or the server.
> > If used carelessly, this can easily waste and drain memory.
> > Currently, a server must have CAP_SYS_ADMIN to manage dmmap regions by
> > mmapping and munmapping the channel fd.
> 
> Does that mean that for example in unionfs-fuse when a user wants to
> mmap a file I can just mmap the actual underlying file from the real
> filesystem and any read/write access would then shortcut fuse and go
> directly to the real file?

No.  It is the /dev/fuse file descriptor that is being mapped to give
access to the "direct mmaped" memory.

Thanks,
Miklos
