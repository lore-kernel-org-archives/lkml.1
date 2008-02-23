Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYBWPZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYBWPZM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 10:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYBWPY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 10:24:58 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29631 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYBWPY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 10:24:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=XflwdS3dxHyXvt/44OXyHmXnu2ez7LEimIgkjMFoFCf8thrYp0ng6SYWKMaufhjBy
	nnJ7g4Iv536OZ8H6kpPJw==
Message-ID: <6599ad830802230724n68dedf5dxc2bd4814646f405c@mail.gmail.com>
Date: Sat, 23 Feb 2008 07:24:51 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cgroup: fix sparse warning of shadow symbol in cgroup.c
Cc: akpm@linux-foundation.org, "Harvey Harrison" <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org, "Cliff Wickman" <cpw@sgi.com>
In-Reply-To: <20080223123357.2668.56473.sendpatchset@jackhammer.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223123357.2668.56473.sendpatchset@jackhammer.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 4:33 AM, Paul Jackson <pj@sgi.com> wrote:
> From: Paul Jackson <pj@sgi.com>
>
>  Fix a code warning: symbol 'p' shadows an earlier one
>
>  This is a reincarnation of Harvey Harrison's patch:
>         cpuset: sparse warnings in cpuset.c
>
>  Independently, Cliff Wickman moved the affected code,
>  from kernel/cpuset.c to kernel/cgroup.c, in his patch:
>         cpusets: update_cpumask revision
>
>  Signed-off-by: Paul Jackson <pj@sgi.com>

Acked-by: Paul Menage <menage@google.com>

>  Cc: Harvey Harrison <harvey.harrison@gmail.com>
>  Cc: Cliff Wickman <cpw@sgi.com>
>
>  ---
>   kernel/cgroup.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
>  --- 2.6.25-rc2-mm1.orig/kernel/cgroup.c 2008-02-16 01:04:48.000000000 -0800
>  +++ 2.6.25-rc2-mm1/kernel/cgroup.c      2008-02-23 04:19:44.006614677 -0800
>  @@ -1897,14 +1897,14 @@ int cgroup_scan_tasks(struct cgroup_scan
>
>         if (heap->size) {
>                 for (i = 0; i < heap->size; i++) {
>  -                       struct task_struct *p = heap->ptrs[i];
>  +                       struct task_struct *q = heap->ptrs[i];
>                         if (i == 0) {
>  -                               latest_time = p->start_time;
>  -                               latest_task = p;
>  +                               latest_time = q->start_time;
>  +                               latest_task = q;
>                         }
>                         /* Process the task per the caller's callback */
>  -                       scan->process_task(p, scan);
>  -                       put_task_struct(p);
>  +                       scan->process_task(q, scan);
>  +                       put_task_struct(q);
>                 }
>                 /*
>                  * If we had to process any tasks at all, scan again
>
>  --
>                           I won't rest till it's the best ...
>                           Programmer, Linux Scalability
>                           Paul Jackson <pj@sgi.com> 1.650.933.1373
>
