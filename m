Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbXEaDg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbXEaDg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 23:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbXEaDgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 23:36:19 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:32827 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053AbXEaDgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 23:36:18 -0400
X-IronPort-AV: i="4.14,596,1170651600"; 
   d="scan'208"; a="40602566:sNHT29368491677"
Subject: Re: [PATCH] [RAMFS NOMMU]: a bug in ramfs_nommu_resize function,
	passing old size to vmtruncate
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: bryan.wu@analog.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <1180582315.10836.2.camel@roc-laptop>
References: <1180582315.10836.2.camel@roc-laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 31 May 2007 11:35:28 +0800
Message-Id: <1180582528.10836.6.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 11:31 +0800, Bryan Wu wrote:
> It should be pass "newsize" to vmtruncate function to modify the
> inode->i_size,
> while the old size is passed to vmtruncate.
> 
> This bug was catched by LTP truncate test case on Blackfin platform.
> After it was fixed, the LTP truncate test case passed.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Cc: David Howells <dhowells@redhat.com>
> ---
>  fs/ramfs/file-nommu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
> index 3b481d5..9345a46 100644
> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -179,7 +179,7 @@ static int ramfs_nommu_resize(struct inode *inode, loff_t newsize, loff_t size)
>                         return ret;
>         }
>  
> -       ret = vmtruncate(inode, size);
> +       ret = vmtruncate(inode, newsize);
>  
>         return ret;
>  }

David: 

Sorry for sending this email several times , my git-send-email got some
problem.

Thanks
-Bryan Wu
