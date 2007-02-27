Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbXB0U07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbXB0U07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXB0U07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:26:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXB0U06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:26:58 -0500
Date: Tue, 27 Feb 2007 12:26:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@gmail.com>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org, aneesh.kumar@gmail.com
Subject: Re: [PATCH] init_new_context: Use the passed task argument
Message-Id: <20070227122644.d2616dc3.akpm@linux-foundation.org>
In-Reply-To: <11722452452225-git-send-email-aneesh.kumar@gmail.com>
References: <11722452363488-git-send-email-aneesh.kumar@gmail.com>
	<11722452452225-git-send-email-aneesh.kumar@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 21:10:36 +0530 "Aneesh Kumar K.V" <aneesh.kumar@gmail.com> wrote:
> From: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@gmail.com>
> ---
>  arch/i386/kernel/ldt.c   |    2 +-
>  arch/x86_64/kernel/ldt.c |    2 +-
>  kernel/fork.c            |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/i386/kernel/ldt.c b/arch/i386/kernel/ldt.c
> index b410e5f..925354c 100644
> --- a/arch/i386/kernel/ldt.c
> +++ b/arch/i386/kernel/ldt.c
> @@ -97,7 +97,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	init_MUTEX(&mm->context.sem);
>  	mm->context.size = 0;
> -	old_mm = current->mm;
> +	old_mm = tsk->mm;
>  	if (old_mm && old_mm->context.size > 0) {
>  		down(&old_mm->context.sem);
>  		retval = copy_ldt(&mm->context, &old_mm->context);
> diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
> index d7e5d0c..16ae79d 100644
> --- a/arch/x86_64/kernel/ldt.c
> +++ b/arch/x86_64/kernel/ldt.c
> @@ -101,7 +101,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	init_MUTEX(&mm->context.sem);
>  	mm->context.size = 0;
> -	old_mm = current->mm;
> +	old_mm = tsk->mm;
>  	if (old_mm && old_mm->context.size > 0) {
>  		down(&old_mm->context.sem);
>  		retval = copy_ldt(&mm->context, &old_mm->context);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index d154cc7..2423d83 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -496,7 +496,7 @@ static struct mm_struct *dup_mm(struct task_struct *tsk)
>  	if (!mm_init(mm))
>  		goto fail_nomem;
>  
> -	if (init_new_context(tsk, mm))
> +	if (init_new_context(current, mm))
>  		goto fail_nocontext;

This last change makes the comment over dup_mm() wrong.  It also generally
makes dup_mm() less useful, although that migt be OK.  It also makes the
argument to dup_mm() unused and potentially removable.


