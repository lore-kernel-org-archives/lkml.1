Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbXIYIsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbXIYIsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXIYIs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:48:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42673 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbXIYIs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:48:27 -0400
Date: Tue, 25 Sep 2007 01:48:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [git] CFS-devel, latest code
Message-Id: <20070925014806.38b58cb7.akpm@linux-foundation.org>
In-Reply-To: <20070925084327.GI26289@linux.vnet.ibm.com>
References: <20070924214537.GA18980@elte.hu>
	<20070925004120.3650c9c1.akpm@linux-foundation.org>
	<20070925084327.GI26289@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 14:13:27 +0530 Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Sep 25, 2007 at 12:41:20AM -0700, Andrew Morton wrote:
> > This doornails the Vaio.  After grub handover the screen remains black
> > and the fan goes whir.
> > 
> > http://userweb.kernel.org/~akpm/config-sony.txt
> 
> This seems to be UP regression. Sorry abt that. I could recreate 
> the problem very easily with CONFIG_SMP turned off.
> 
> Can you check if this patch works? Works for me here.
> 
> --
> 
> Fix UP breakage.
> 
> Signed-off-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> 
> ---
>  kernel/sched.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: current/kernel/sched.c
> ===================================================================
> --- current.orig/kernel/sched.c
> +++ current/kernel/sched.c
> @@ -1029,8 +1029,8 @@ static inline void __set_task_cpu(struct
>  {
>  #ifdef CONFIG_SMP
>  	task_thread_info(p)->cpu = cpu;
> -	set_task_cfs_rq(p);
>  #endif
> +	set_task_cfs_rq(p);
>  }
>  
>  #ifdef CONFIG_SMP

yup, that's a fix.  It was 15 minutes too late for rc8-mm1 though :(
