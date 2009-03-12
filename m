Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZCLCnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZCLCnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZCLCnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:43:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbZCLCnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:43:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=khp5pdBGiDa18QLBsqIonwWfX0LyMNHULn8+ZLZZHXz9uKUwp5U8Bi6fABuVq7gDN
	WBouInhKrE8CTETFgfZhQ==
MIME-Version: 1.0
In-Reply-To: <49B869B7.1090108@cn.fujitsu.com>
References: <49B869B7.1090108@cn.fujitsu.com>
Date: Wed, 11 Mar 2009 19:43:32 -0700
Message-ID: <6599ad830903111943u2799333dh680470f9daa6ccbb@mail.gmail.com>
Subject: Re: [PATCH] debug cgroup: remove unneeded cgroup_lock
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 6:47 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Since we are in cgroup write handler, so the cgrp is valid, so we
> don't have to hold cgroup_mutex when calling cgroup_task_count().
> One similar example is in cgroup_tasks_open().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

(Although this conflicts with a patch that I'm about to send out that
moves the code from cgroup_debug.c into cgroup.c to allow internal
details to be reported in the debug.* files.)

> ---
>  kernel/cgroup_debug.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup_debug.c b/kernel/cgroup_debug.c
> index daca620..0c92d79 100644
> --- a/kernel/cgroup_debug.c
> +++ b/kernel/cgroup_debug.c
> @@ -40,9 +40,7 @@ static u64 taskcount_read(struct cgroup *cont, struct cftype *cft)
>  {
>        u64 count;
>
> -       cgroup_lock();
>        count = cgroup_task_count(cont);
> -       cgroup_unlock();
>        return count;
>  }
>
> --
> 1.5.4.rc3
>
>
