Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbXFPQPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbXFPQPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXFPQPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:15:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53725 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753AbXFPQPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:15:36 -0400
Date: Sat, 16 Jun 2007 09:15:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] NFS: Make NFS root work again
Message-Id: <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
In-Reply-To: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
References: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jun 2007 17:40:03 +0100 David Howells <dhowells@redhat.com> wrote:

> Make NFS root work by creating a "/root" directory to satisfy the mount,
> otherwise the path lookup for the mount fails with ENOENT.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  init/do_mounts.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index 46fe407..967b852 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -270,7 +270,10 @@ static void __init get_fs_names(char *page)
>  
>  static int __init do_mount_root(char *name, char *fs, int flags, void *data)
>  {
> -	int err = sys_mount(name, "/root", fs, flags, data);
> +	int err;
> +
> +	sys_mkdir("/root", 0755);
> +	err = sys_mount(name, "/root", fs, flags, data);
>  	if (err)
>  		return err;

Am still awaiting a proper description of this patch, please.

What is not working, and how does this patch fix it?

I am unaware of any open bug reports against NFS root.
