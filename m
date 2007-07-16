Return-Path: <linux-kernel-owner+w=401wt.eu-S1763861AbXGPUow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763861AbXGPUow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763665AbXGPUoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:44:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54124 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763648AbXGPUod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:44:33 -0400
Date: Mon, 16 Jul 2007 13:44:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>, Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: wrong order of arguments of ->readdir()
Message-Id: <20070716134424.0cd870b4.akpm@linux-foundation.org>
In-Reply-To: <200707152359.l6FNx3oN023117@hera.kernel.org>
References: <200707152359.l6FNx3oN023117@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 23:59:03 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7c9e3c2e3b0437d10a09b77769baf325b94aa436
> Commit:     7c9e3c2e3b0437d10a09b77769baf325b94aa436
> Parent:     53b67950026ee642b43615f46df22ec3d36b4a53
> Author:     Al Viro <viro@ftp.linux.org.uk>
> AuthorDate: Sun Jul 15 20:59:31 2007 +0100
> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
> CommitDate: Sun Jul 15 16:40:51 2007 -0700
> 
>     wrong order of arguments of ->readdir()
>     
>     Shows how many people are testing coda - the bug had been there for 5 years
>     and results of stepping on it are not subtle.
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  fs/coda/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/coda/dir.c b/fs/coda/dir.c
> index 9ddf5ed..898a86d 100644
> --- a/fs/coda/dir.c
> +++ b/fs/coda/dir.c
> @@ -470,7 +470,7 @@ int coda_readdir(struct file *coda_file, void *dirent, filldir_t filldir)
>  
>  		ret = -ENOENT;
>  		if (!IS_DEADDIR(host_inode)) {
> -			ret = host_file->f_op->readdir(host_file, filldir, dirent);
> +			ret = host_file->f_op->readdir(host_file, dirent, filldir);
>  			file_accessed(host_file);
>  		}
>  	}

Today is not being a good day.

This bug was already fixed.   The following mistakes were made:

a) Jan's patch was misleadingly titled "coda: avoid lockdep warning in
   coda_readdir"

b) Jan's patch had no changelog

c) Jen's patch was not cc'ed to any mailing list

d) Al's patch was not sent to the maintainer.  Nor to me.  Nor was it
   staged in any tree which I can get at so that I could inform people of
   the upcoming conflict/duplication/etc.


Guys (and I mean all guys): things are really shit at present.  Please try
to do better.

