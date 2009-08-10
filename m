Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZHJO40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZHJO40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZHJO4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:56:25 -0400
Received: from cmpxchg.org ([85.214.51.133]:35799 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbZHJO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:56:24 -0400
Date: Mon, 10 Aug 2009 16:56:41 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/3] vfs: remove redundant position check in do_sendfile
Message-ID: <20090810145641.GB4925@cmpxchg.org>
References: <1249906663-7572-1-git-send-email-jlayton@redhat.com> <1249906663-7572-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249906663-7572-3-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 08:17:42AM -0400, Jeff Layton wrote:
> As Johannes Weiner pointed out, one of the range checks in do_sendfile
> is redundant and is already checked in rw_verify_area.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks!

> ---
>  fs/read_write.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 6c8c55d..3ac2898 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -839,9 +839,6 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
>  		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
>  
>  	pos = *ppos;
> -	retval = -EINVAL;
> -	if (unlikely(pos < 0))
> -		goto fput_out;
>  	if (unlikely(pos + count > max)) {
>  		retval = -EOVERFLOW;
>  		if (pos >= max)
> -- 
> 1.6.0.6
