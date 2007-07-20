Return-Path: <linux-kernel-owner+w=401wt.eu-S1765165AbXGTAmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765165AbXGTAmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbXGTAmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:42:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758077AbXGTAmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:42:46 -0400
Date: Thu, 19 Jul 2007 17:42:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Diego Woitasen <diego@woitasen.com.ar>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the tsk argument in init_new_context()
Message-Id: <20070719174238.fab0d079.akpm@linux-foundation.org>
In-Reply-To: <1183946108509-git-send-email-diego@woitasen.com.ar>
References: <1183946108509-git-send-email-diego@woitasen.com.ar>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Jul 2007 22:55:08 -0300
Diego Woitasen <diego@woitasen.com.ar> wrote:

> Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
> ---
>  arch/i386/kernel/ldt.c   |    2 +-
>  arch/x86_64/kernel/ldt.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/i386/kernel/ldt.c b/arch/i386/kernel/ldt.c
> index e0b2d17..c2eb4fb 100644
> --- a/arch/i386/kernel/ldt.c
> +++ b/arch/i386/kernel/ldt.c
> @@ -96,7 +96,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	init_MUTEX(&mm->context.sem);
>  	mm->context.size = 0;
> -	old_mm = current->mm;
> +	old_mm = tsk->mm;
>  	if (old_mm && old_mm->context.size > 0) {
>  		down(&old_mm->context.sem);
>  		retval = copy_ldt(&mm->context, &old_mm->context);
> diff --git a/arch/x86_64/kernel/ldt.c b/arch/x86_64/kernel/ldt.c
> index bc9ffd5..99a92ed 100644
> --- a/arch/x86_64/kernel/ldt.c
> +++ b/arch/x86_64/kernel/ldt.c
> @@ -100,7 +100,7 @@ int init_new_context(struct task_struct *tsk, struct mm_struct *mm)
>  
>  	init_MUTEX(&mm->context.sem);
>  	mm->context.size = 0;
> -	old_mm = current->mm;
> +	old_mm = tsk->mm;
>  	if (old_mm && old_mm->context.size > 0) {
>  		down(&old_mm->context.sem);
>  		retval = copy_ldt(&mm->context, &old_mm->context);


When called from dup_mm(), `tsk' refers to the new task and `current'
refers to the old one.  I'd have expected this to crash during your testing?
