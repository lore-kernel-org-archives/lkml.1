Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbXFGR5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbXFGR5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763733AbXFGR5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:57:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765131AbXFGR5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:57:19 -0400
Message-ID: <466846DB.6090907@redhat.com>
Date: Thu, 07 Jun 2007 13:56:43 -0400
From: Peter Staubach <staubach@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070529)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@osdl.org, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] NFS: Make NFS root work again
References: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
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

It seems to me that if sys_mkdir() fails with anything other other
than EEXISTS, then sys_mount() will continue to fail.  Is this
something that we care about?

       ps
