Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbXGHRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbXGHRhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbXGHRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:37:28 -0400
Received: from smtp-out-43.synserver.de ([217.119.50.43]:1043 "HELO
	smtp-out-43.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751935AbXGHRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:37:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-RemoteDnsName: port-212-202-34-50.dynamic.qsc.de
Date: Sun, 8 Jul 2007 19:33:46 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer
	dereference  - git-bisect result
Message-ID: <20070708173346.GA4167@gentoox2.trippelsdorf.de>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de> <20070708012016.455ce8d5.akpm@linux-foundation.org> <20070708100911.GA4196@gentoox2.trippelsdorf.de> <20070708152808.GA5902@gentoox2.trippelsdorf.de> <469119A3.6030409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469119A3.6030409@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 10:06:43AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Markus Trippelsdorf wrote:
> > I tested this further and it turned out that the Linus tree is also
> > affected. So I ran git-bisect, after I found out that version
> > 2.6.21.6 was not affected by this bug.
> 
> Try this patch.  The vfs_permission test can be skipped since the VFS
> isn't involved.  We got the inode etc from a file descriptor.
> 
> 
> Signed-Off-By: Ulrich Drepper <drepper@redhat.com>
> 
> diff --git a/fs/utimes.c b/fs/utimes.c
> index 480f7c8..873edcb 100644
> - --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -106,7 +106,8 @@ long do_utimes(int dfd, char __user *filename, struct timespec *times, int flags
>                  if (IS_IMMUTABLE(inode))
>                          goto dput_and_out;
> 
> - -               if (current->fsuid != inode->i_uid &&
> +               if (f == NULL &&
> +                   current->fsuid != inode->i_uid &&
>                     (error = vfs_permission(&nd, MAY_WRITE)) != 0)
>                         goto dput_and_out;
>         }
> 
> 

I had to hand apply the patch, but it solved the problem.
Thanks.
-- 
Markus
