Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0BJIYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:24:17 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:45912 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab0BJIYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:24:15 -0500
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
       fuse-devel@lists.sourceforge.net,
       Lars Wendler <polynomial-c@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org>
Date: Wed, 10 Feb 2010 09:24:13 +0100
In-Reply-To: <4B70FBE4.7050700@kernel.org> (Tejun Heo's message of "Tue, 09
	Feb 2010 15:08:36 +0900")
Message-ID: <87k4ulo5w2.fsf@frosties.localdomain>
User-Agent: Gnus/5.110009 (No Gnus v0.9) XEmacs/21.4.22 (linux, no MULE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1++wfkEQ4HjpCA88z+4hKMPkH46rziI+Y1CwXTc
	WHwsJpil0Zf9sHMvRPjypheaO55mcBuDlDo682QpisJba/Rktf
	ud3tlCr1U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Implement FUSE direct mmap support.  The server can redirect client
> mmap requests to any SHMLBA aligned offset in the custom address space
> attached to the fuse channel.  The address space is managed by the
> server using mmap/munmap(2).  The SHMLBA alignment requirement is
> necessary to avoid cache aliasing issues on archs with virtually
> indexed caches as FUSE direct mmaps are basically shared memory
> between clients and the server.
>
> The direct mmap address space is backed by pinned kernel pages which
> are allocated on the first fault either from a client or the server.
> If used carelessly, this can easily waste and drain memory.
> Currently, a server must have CAP_SYS_ADMIN to manage dmmap regions by
> mmapping and munmapping the channel fd.

Does that mean that for example in unionfs-fuse when a user wants to
mmap a file I can just mmap the actual underlying file from the real
filesystem and any read/write access would then shortcut fuse and go
directly to the real file?

MfG
        Goswin
