Return-Path: <linux-kernel-owner+w=401wt.eu-S1161346AbXCONwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161346AbXCONwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 09:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161347AbXCONwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 09:52:43 -0400
Received: from mail.suse.de ([195.135.220.2]:54422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161346AbXCONwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 09:52:42 -0400
Date: Thu, 15 Mar 2007 14:52:41 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] oom fix: prevent oom from killing a process with children/sibling unkillable
Message-ID: <20070315135241.GG8321@wotan.suse.de>
References: <20070315134921.GD18033@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315134921.GD18033@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 07:19:21PM +0530, Ankita Garg wrote:
> 
> Looking at oom_kill.c, found that the intention to not kill the selected
> process if any of its children/siblings has OOM_DISABLE set, is not being met.
> 
> 
> Signed-off-by: Ankita Garg <ankita@in.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>

> 
> Index: ankita/linux-2.6.20.1/mm/oom_kill.c
> ===================================================================
> --- ankita.orig/linux-2.6.20.1/mm/oom_kill.c	2007-02-20 12:04:32.000000000 +0530
> +++ ankita/linux-2.6.20.1/mm/oom_kill.c	2007-03-15 12:44:50.000000000 +0530
> @@ -320,7 +320,7 @@
>  	 * Don't kill the process if any threads are set to OOM_DISABLE
>  	 */
>  	do_each_thread(g, q) {
> -		if (q->mm == mm && p->oomkilladj == OOM_DISABLE)
> +		if (q->mm == mm && q->oomkilladj == OOM_DISABLE)
>  			return 1;
>  	} while_each_thread(g, q);
>  
> 
> Regards,
> -- 
> Ankita Garg (ankita@in.ibm.com)
> Linux Technology Center
> IBM India Systems & Technology Labs, 
> Bangalore, India   
