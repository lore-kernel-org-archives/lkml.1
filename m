Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbZHXE7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbZHXE7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZHXE7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:59:05 -0400
Received: from tundra.namei.org ([65.99.196.166]:36648 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbZHXE7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:59:04 -0400
Date: Mon, 24 Aug 2009 14:58:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
       Roland Kletzing <devzero@web.de>,
       "<David Safford" <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/2] kernel_read: redefine offset type
In-Reply-To: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.00.0908241458010.22597@tundra.namei.org>
References: <df9691ba169503565c2e3b71c593f9c43a6b3eb2.1250871856.git.zohar@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Mimi Zohar wrote:

> vfs_read() offset is defined as loff_t, but kernel_read()
> offset is only defined as unsigned long. Redefine
> kernel_read() offset as loff_t.
> 
> Cc: stable@kernel.org
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>


Reviewed-by: James Morris <jmorris@namei.org>

> ---
>  fs/exec.c          |    4 ++--
>  include/linux/fs.h |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 4a8849e..fb4f3cd 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -678,8 +678,8 @@ exit:
>  }
>  EXPORT_SYMBOL(open_exec);
>  
> -int kernel_read(struct file *file, unsigned long offset,
> -	char *addr, unsigned long count)
> +int kernel_read(struct file *file, loff_t offset,
> +		char *addr, unsigned long count)
>  {
>  	mm_segment_t old_fs;
>  	loff_t pos = offset;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 67888a9..73e9b64 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2123,7 +2123,7 @@ extern struct file *do_filp_open(int dfd, const char *pathname,
>  		int open_flag, int mode, int acc_mode);
>  extern int may_open(struct path *, int, int);
>  
> -extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
> +extern int kernel_read(struct file *, loff_t, char *, unsigned long);
>  extern struct file * open_exec(const char *);
>   
>  /* fs/dcache.c -- generic fs support functions */
> -- 
> 1.6.0.6
> 

-- 
James Morris
<jmorris@namei.org>
