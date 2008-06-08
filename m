Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYFHUJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYFHUJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYFHUJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:09:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754905AbYFHUJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:09:42 -0400
Date: Sun, 8 Jun 2008 13:09:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@jp.fujitsu.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] introduce sysctl of throttle
Message-Id: <20080608130935.ea7076fc.akpm@linux-foundation.org>
In-Reply-To: <20080605021505.694195095@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com>
	<20080605021505.694195095@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 11:12:16 +0900 kosaki.motohiro@jp.fujitsu.com wrote:

> introduce sysctl parameter of max task of throttle.
> 
> <usage>
>  # echo 5 > /proc/sys/vm/max_nr_task_per_zone
> </usage>
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> ---
>  include/linux/swap.h |    2 ++
>  kernel/sysctl.c      |    9 +++++++++
>  mm/vmscan.c          |    4 +++-
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -125,9 +125,11 @@ struct scan_control {
>  int vm_swappiness = 60;
>  long vm_total_pages;	/* The total number of pages which the VM controls */
>  
> -#define MAX_RECLAIM_TASKS CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE
> +#define MAX_RECLAIM_TASKS vm_max_nr_task_per_zone
>  static LIST_HEAD(shrinker_list);
>  static DECLARE_RWSEM(shrinker_rwsem);
> +int vm_max_nr_task_per_zone __read_mostly
> +       = CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE;

It would be nice if we could remove
CONFIG_NR_MAX_RECLAIM_TASKS_PER_ZONE altogether.  Its a pretty obscure
thing and we haven't provided people wait any information which would
permit them to tune it anwyay.

In which case this patch should be folded into [4/5].


