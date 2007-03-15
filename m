Return-Path: <linux-kernel-owner+w=401wt.eu-S1422963AbXCOWWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422963AbXCOWWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933822AbXCOWWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:22:14 -0400
Received: from holomorphy.com ([66.93.40.71]:35815 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbXCOWWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:22:11 -0400
Date: Thu, 15 Mar 2007 15:22:11 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] oom fix: prevent oom from killing a process with children/sibling unkillable
Message-ID: <20070315222211.GW2986@holomorphy.com>
References: <20070315134921.GD18033@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315134921.GD18033@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 07:19:21PM +0530, Ankita Garg wrote:
> Looking at oom_kill.c, found that the intention to not kill the selected
> process if any of its children/siblings has OOM_DISABLE set, is not being met.
> Signed-off-by: Ankita Garg <ankita@in.ibm.com>
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

Acked-by: William Irwin <wli@holomorphy.com>


-- wli
