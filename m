Return-Path: <linux-kernel-owner+w=401wt.eu-S934777AbYBWIMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777AbYBWIMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbYBWIIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:39 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932770AbYBWIIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:37 -0500
Date: Sat, 23 Feb 2008 00:04:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: sparse warnings in cpuset.c
Message-Id: <20080223000434.7322d1c9.akpm@linux-foundation.org>
In-Reply-To: <1202024543.1844.57.camel@brick>
References: <1202019619.1844.52.camel@brick>
	<20080203012815.05a50b13.pj@sgi.com>
	<1202024543.1844.57.camel@brick>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Feb 2008 23:42:23 -0800 Harvey Harrison <harvey.harrison@gmail.com> wrote:

        ^^^^^^ I suck.

> Don't redeclare p, use a new variable q.
> 
> kernel/cpuset.c:824:23: warning: symbol 'p' shadows an earlier one
> kernel/cpuset.c:746:21: originally declared here
> kernel/cpuset.c:1272:52: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Paul, used a variable q instead as per your request.
> 
>  kernel/cpuset.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index cfaf641..ce0cfff 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -821,13 +821,13 @@ static int update_cpumask(struct cpuset *cs, char *buf)
>  	cgroup_iter_end(cgrp, &it);
>  	if (heap.size) {
>  		for (i = 0; i < heap.size; i++) {
> -			struct task_struct *p = heap.ptrs[i];
> +			struct task_struct *q = heap.ptrs[i];
>  			if (i == 0) {
> -				latest_time = p->start_time;
> -				latest_task = p;
> +				latest_time = q->start_time;
> +				latest_task = q;
>  			}
> -			set_cpus_allowed(p, cs->cpus_allowed);
> -			put_task_struct(p);
> +			set_cpus_allowed(q, cs->cpus_allowed);
> +			put_task_struct(q);
>  		}
>  		/*
>  		 * If we had to process any tasks at all, scan again

Sorry, the above code doesn't seem to exist any more.
