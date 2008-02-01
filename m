Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYBAViY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYBAViY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYBAViP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:38:15 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60356 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYBAViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:38:14 -0500
To: staubach@redhat.com
CC: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org
In-reply-to: <47A387D4.70605@redhat.com> (message from Peter Staubach on Fri,
	01 Feb 2008 15:57:56 -0500)
Subject: Re: [PATCH 2/3] enhanced syscall ESTALE error handling (v2)
References: <4790C768.4080207@redhat.com> <47A387D4.70605@redhat.com>
Message-Id: <E1JL3a0-0006H7-U3@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 01 Feb 2008 22:37:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This doesn't apply to -mm, because the ro-mounts stuff touches a lot
of the same places as this patch.  You probably need to rebase this on
top of those changes.

> This patch adds handling for the error, ESTALE, to the system
> calls which take pathnames as arguments.  The algorithm used
> is to detect that an ESTALE error has occurred during an
> operation subsequent to the lookup process and then to unwind
> appropriately and then to perform the lookup process again.
> Eventually, either the lookup process will return an error
> or a valid dentry/inode combination and then operation can
> succeed or fail based on its own merits.

If a broken NFS server or FUSE filesysem keeps returning ESTALE, this
goes into an infinite loop.  How are we planning to deal with that?

And it has to be dealt with either in the VFS, or in the kernel parts
of the relevant filesystems.  We can't just say, fix the broken
servers, especially not with FUSE, where the server is totally
untrusted.

Miklos
