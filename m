Return-Path: <linux-kernel-owner+w=401wt.eu-S1760247AbXEROhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247AbXEROhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbXEROhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:37:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:50244 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXEROhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:37:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=s8aNN0MDf0OiW5gEl11G4wsAZIVK+1LwAkQmv3Sq4O7Q+NaMLweQ9nLtz3Rdu562F
	Wr5ttLCBdlsv8UaH6soxg==
Message-ID: <6599ad830705180737m6aee5ca2x9c39613f782cda67@mail.gmail.com>
Date: Fri, 18 May 2007 07:37:28 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix a simple issue w.r.t mounting of containers
Cc: "Paul Jackson" <pj@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070518123916.21450.21761.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070518123916.21450.21761.sendpatchset@balbir-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I've added that to my tree.

Paul

On 5/18/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>
> Fix containers mounting issue. With the current v9 patches if a container
> hierarchy is mounted and then umounted. A second mount of the hierarchy
> fails
>
> Steps to reproduce the problem
>
> 1. mount -t container container /<mnt point>
> 2. umount /<mnt point>
> 3. mount -t container container /<mnt point>
>
> Step 3 fails with -EBUSY. This is due to the fact that when we unmount,
> in container_put_super(), we need to delete the current root from the roots
> list.
>
> The patch below fixes the issue
>
>
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> ---
>
>  kernel/container.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff -puN kernel/container.c~fix-remount-issue kernel/container.c
> --- linux-2.6.21-mm1/kernel/container.c~fix-remount-issue       2007-05-18 17:59:40.000000000 +0530
> +++ linux-2.6.21-mm1-balbir/kernel/container.c  2007-05-18 18:00:02.000000000 +0530
> @@ -574,6 +574,7 @@ static void container_put_super(struct s
>         ret = rebind_subsystems(root, 0);
>         BUG_ON(ret);
>
> +       list_del(&root->root_list);
>         kfree(root);
>         mutex_unlock(&container_mutex);
>  }
> _
>
> --
>         Warm Regards,
>         Balbir Singh
>         Linux Technology Center
>         IBM, ISTL
>
