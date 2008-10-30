Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbYJ3LHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbYJ3LHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYJ3LGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:06:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56519 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYJ3LGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:06:54 -0400
Date: Thu, 30 Oct 2008 12:06:53 +0100
From: Pavel Machek <pavel@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] corruption checker: print the DMI board name
Message-ID: <20081030110653.GA7291@atrey.karlin.mff.cuni.cz>
References: <20081029091703.47628e54@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029091703.47628e54@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> >From 4f829eef5a31b68a0cbaf83a75ac8b0a1ed05afb Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 29 Oct 2008 09:13:23 -0700
> Subject: [PATCH] corruption checker: print the DMI board name
> 
> when the memory corruptor checker hits (as it has done now based on kerneloops.org data),
> it would be extremely useful to know the DMI board name so we can add a blacklist for
> such a machine... without having to ask the user for lots of extra info.

I'm not sure if blacklisting whole brand for one case of bit
corruption is fair -- perhaps the memory was overheating?

  
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

But ACK -- we certainly want to see the data.

> ---
>  arch/x86/kernel/check.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
> index 2ac0ab7..f952182 100644
> --- a/arch/x86/kernel/check.c
> +++ b/arch/x86/kernel/check.c
> @@ -2,6 +2,7 @@
>  #include <linux/sched.h>
>  #include <linux/kthread.h>
>  #include <linux/workqueue.h>
> +#include <linux/dmi.h>
>  #include <asm/e820.h>
>  #include <asm/proto.h>
>  
> @@ -113,6 +114,7 @@ void check_for_bios_corruption(void)
>  {
>  	int i;
>  	int corruption = 0;
> +	const char *board;
>  
>  	if (!memory_corruption_check)
>  		return;
> @@ -131,7 +133,11 @@ void check_for_bios_corruption(void)
>  		}
>  	}
>  
> -	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\n");
> +	board = dmi_get_system_info(DMI_PRODUCT_NAME);
> +	if (!board)
> +		board = "";
> +	WARN_ONCE(corruption, KERN_ERR "Memory corruption detected in low memory\nBoard name: %s\n",
> +		board);
>  }
>  
>  static void check_corruption(struct work_struct *dummy);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
