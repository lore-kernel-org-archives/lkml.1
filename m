Return-Path: <linux-kernel-owner+w=401wt.eu-S935523AbZLQBrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935523AbZLQBrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763683AbZLQBqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:46:40 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3474 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763609AbZLQBqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:46:31 -0500
Message-ID: <4B298B2A.5010900@caviumnetworks.com>
Date: Wed, 16 Dec 2009 17:36:42 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Csaba Henk <csaba@gluster.com>,
       Miklos Szeredi <mszeredi@suse.cz>, Harshavardhana <harsha@gluster.com>
Subject: Re: [04/18] fuse: reject O_DIRECT flag also in fuse_create
References: <20091217004707.472856791@mini.kroah.org>
In-Reply-To: <20091217004707.472856791@mini.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2009 01:36:43.0168 (UTC) FILETIME=[6330EA00:01CA7EB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Csaba Henk <csaba@gluster.com>
> 
> commit 1b7323965a8c6eee9dc4e345a7ae4bff1dc93149 upstream.
> 
> The comment in fuse_open about O_DIRECT:
> 
>   "VFS checks this, but only _after_ ->open()"
> 
> also holds for fuse_create, however, the same kind of check was missing there.
> 
> As an impact of this bug, open(newfile, O_RDWR|O_CREAT|O_DIRECT) fails, but a
> stub newfile will remain if the fuse server handled the implied FUSE_CREATE
> request appropriately.
> 
> Other impact: in the above situation ima_file_free() will complain to open/free
> imbalance if CONFIG_IMA is set.
> 
> Signed-off-by: Csaba Henk <csaba@gluster.com>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Harshavardhana <harsha@gluster.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  fs/fuse/dir.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -401,6 +401,9 @@ static int fuse_create_open(struct inode
>  	if (flags & O_DIRECT)
>  		return -EINVAL;
>  
> +	if (flags & O_DIRECT)
> +		return -EINVAL;
> +

I must be missing something.  The added part seems to be identical to 
the lines just above.

Forgive me if I am totally misreading the diff.

David Daney


>  	forget_req = fuse_get_req(fc);
>  	if (IS_ERR(forget_req))
>  		return PTR_ERR(forget_req);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

