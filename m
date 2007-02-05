Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbXBEKCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbXBEKCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 05:02:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXBEKCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 05:02:41 -0500
Received: from styx.suse.cz ([82.119.242.94]:7307 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752258AbXBEKCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 05:02:40 -0500
X-Greylist: delayed 1064 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Feb 2007 05:02:40 EST
Date: Mon, 5 Feb 2007 10:47:34 +0100
From: Jan Kara <jack@suse.cz>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] QUOTA: Have <linux/quota.h> include <linux/rwsem.h> explicitly.
Message-ID: <20070205094733.GA31641@duck.suse.cz>
References: <Pine.LNX.4.64.0702041021310.20978@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702041021310.20978@CPE00045a9c397f-CM001225dbafb6>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 04-02-07 10:46:33, Robert P. J. Day wrote:
> 
>   Since quota.h declares a R/W semaphore, it should include rwsem.h
> explicitly.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
> 
>   No, this doesn't fix an *existing* problem, but it's necessary for
> an upcoming patch which will remove all includes of <linux/rwsem.h>
> from all the semaphore.h files.
> 
>   As I read it, since R/W semaphores have their own header file,
> there's no rationale for the regular semaphore header files to have
> that include statement, so any header file that's been happily picking
> up the rwsem header file by accident (via semaphore.h) should be fixed
> this way.
> 
>   quota.h appears to be the only file that has this issue building on
> x86 with "make allyesconfig".
> 
> 
> diff --git a/include/linux/quota.h b/include/linux/quota.h
> index b8fbf26..77db80a 100644
> --- a/include/linux/quota.h
> +++ b/include/linux/quota.h
> @@ -132,6 +132,7 @@ struct if_dqinfo {
> 
>  #ifdef __KERNEL__
>  #include <linux/spinlock.h>
> +#include <linux/rwsem.h>
>  #include <linux/mutex.h>
> 
>  #include <linux/dqblk_xfs.h>
> 
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
> ========================================================================

										Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
