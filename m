Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbZGOBtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbZGOBtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZGOBtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:49:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53673 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZGOBtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:49:20 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
Cc: kosaki.motohiro@jp.fujitsu.com, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de
In-Reply-To: <20090714210557.0f983c37@bree.surriel.com>
References: <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com> <20090714210557.0f983c37@bree.surriel.com>
Message-Id: <20090715104645.39A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Jul 2009 10:49:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After moving the oom_adj value from the task struct to the
> mm_struct, the oom_adj value was no longer properly inherited
> by child processes.
> 
> Copying over the oom_adj value at fork time fixes that bug.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Reported-by: Paul Menage <manage@google.com>
> ---
> Paul, does this fix your bug?
> 
>  kernel/fork.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: mmotm/kernel/fork.c
> ===================================================================
> --- mmotm.orig/kernel/fork.c	2009-07-14 20:58:01.000000000 -0400
> +++ mmotm/kernel/fork.c	2009-07-14 21:00:40.000000000 -0400
> @@ -435,6 +435,7 @@ static struct mm_struct * mm_init(struct
>  	init_rwsem(&mm->mmap_sem);
>  	INIT_LIST_HEAD(&mm->mmlist);
>  	mm->flags = (current->mm) ? current->mm->flags : default_dump_filter;
> +	mm->oom_adj = current->mm->oom_adj;

Maybe, We need to check "(current->mm) != NULL" as mm->flags.



>  	mm->core_state = NULL;
>  	mm->nr_ptes = 0;
>  	set_mm_counter(mm, file_rss, 0);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



