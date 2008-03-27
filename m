Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbYC0DPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbYC0DPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbYC0DO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:14:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33117 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633AbYC0DOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:14:55 -0400
Date: Wed, 26 Mar 2008 20:14:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: set relay file can not be read by pread(2)
Message-Id: <20080326201428.95b4a3f6.akpm@linux-foundation.org>
In-Reply-To: <200803261859.m2QIx6rZ025917@hera.kernel.org>
References: <200803261859.m2QIx6rZ025917@hera.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 18:59:06 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=37529fe9f62835e1c11895a1895064748b032dc1
> Commit:     37529fe9f62835e1c11895a1895064748b032dc1
> Parent:     05dda977f2574c3341abef9b74c27d2b362e1e3a
> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> AuthorDate: Wed Mar 26 12:01:28 2008 +0100
> Committer:  Jens Axboe <jens.axboe@oracle.com>
> CommitDate: Wed Mar 26 12:01:28 2008 +0100
> 
>     set relay file can not be read by pread(2)
>     
>     I found that relay files can be read by pread(2). I fix it,
>     for relay files are not capable of seeking.
>     
>     Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>     Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  kernel/relay.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 4c035a8..ed3f6cf 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -736,7 +736,7 @@ static int relay_file_open(struct inode *inode, struct file *filp)
>  	kref_get(&buf->kref);
>  	filp->private_data = buf;
>  
> -	return 0;
> +	return nonseekable_open(inode, filp);
>  }

Does pread(..., ..., ..., offset=0) work correctly now?

Because if it does, then applications might be using that, and we just
broke them.

