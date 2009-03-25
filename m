Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZCYCI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZCYCI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 22:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZCYCIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 22:08:19 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:49255 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbZCYCIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 22:08:19 -0400
X-IronPort-AV: E=Sophos;i="4.38,416,1233550800"; 
   d="scan'208";a="85039437"
Subject: Re: [Uclinux-dist-devel] [PATCH 04/13] [blackfin] changed ioctls
 to unlocked
From: gyang <graf.yang@analog.com>
To: stoyboyker@gmail.com
CC: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1237929168-15341-5-git-send-email-stoyboyker@gmail.com>
References: <1237929168-15341-5-git-send-email-stoyboyker@gmail.com>
Content-Type: text/plain
Date: Wed, 25 Mar 2009 10:07:56 +0800
Message-ID: <1237946876.5927.3.camel@dy>
MIME-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2009 02:08:13.0096 (UTC) FILETIME=[8D61CA80:01C9ACEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you add some comment for this patch?

On Tue, 2009-03-24 at 16:12 -0500, stoyboyker@gmail.com wrote:
> From: Stoyan Gaydarov <stoyboyker@gmail.com>
> 
> Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
> ---
>  arch/blackfin/mach-bf561/coreb.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/blackfin/mach-bf561/coreb.c b/arch/blackfin/mach-bf561/coreb.c
> index 8598098..9ad89af 100644
> --- a/arch/blackfin/mach-bf561/coreb.c
> +++ b/arch/blackfin/mach-bf561/coreb.c
> @@ -220,9 +220,10 @@ static int coreb_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> -static int coreb_ioctl(struct inode *inode, struct file *file,
> -		       unsigned int cmd, unsigned long arg)
> +static long coreb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
> +	lock_kernel();
> +
>  	int retval = 0;
>  	int coreb_index = 0;
>  
> @@ -289,6 +290,7 @@ static int coreb_ioctl(struct inode *inode, struct file *file,
>  #endif
>  	}
>  
> +	unlock_kernel();
>  	return retval;
>  }
>  
> @@ -297,7 +299,7 @@ static struct file_operations coreb_fops = {
>  	.llseek = coreb_lseek,
>  	.read = coreb_read,
>  	.write = coreb_write,
> -	.ioctl = coreb_ioctl,
> +	.unlocked_ioctl = coreb_ioctl,
>  	.open = coreb_open,
>  	.release = coreb_release
>  };
