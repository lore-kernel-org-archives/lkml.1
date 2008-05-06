Return-Path: <linux-kernel-owner+w=401wt.eu-S1756643AbYEFGaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbYEFGaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYEFG3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:29:55 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41138 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYEFG3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:29:54 -0400
Message-ID: <481FFAAB.3030008@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 11:58:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: on CONFIG_MM_OWNER=y, kernel panic is possible.
References: <481FF115.8030503@linux.vnet.ibm.com> <20080506150213.AC63.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080506151510.AC66.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080506151510.AC66.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>> That is not possible. If you look at where mm_update_next_owner() is called
>>> from, we call it from
>>>
>>> exit_mm() and exec_mmap()
>>>
>>> In both cases, we ensure that the task's mm has changed (to NULL and the new mm
>>> respectively), before we call mm_update_next_owner(), hence c->mm can never be
>>> equal to p->mm.
>> if so, following patch is needed instead.
> 
> and, one more.
> 
> comment of owner member of mm_struct is bogus.
> that is not guranteed point to thread-group-leader.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  include/linux/mm_types.h |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: b/include/linux/mm_types.h
> ===================================================================
> --- a/include/linux/mm_types.h  2008-05-04 22:56:52.000000000 +0900
> +++ b/include/linux/mm_types.h  2008-05-06 15:53:04.000000000 +0900
> @@ -231,8 +231,7 @@ struct mm_struct {
>         rwlock_t                ioctx_list_lock;        /* aio lock */
>         struct kioctx           *ioctx_list;
>  #ifdef CONFIG_MM_OWNER
> -       struct task_struct *owner;      /* The thread group leader that */
> -                                       /* owns the mm_struct.          */
> +       struct task_struct *owner;      /* point to one of task that owns the mm_struct. */
>  #endif
> 
>  #ifdef CONFIG_PROC_FS
> 
> 
> 

How about just, the task that owns the mm_struct? One of, implies multiple owners.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
