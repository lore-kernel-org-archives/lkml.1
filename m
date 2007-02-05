Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXBEFkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXBEFkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 00:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbXBEFkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 00:40:22 -0500
Received: from rex.snapgear.com ([203.143.235.140]:49749 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbXBEFkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 00:40:21 -0500
Message-ID: <45C6C33D.1010504@snapgear.com>
Date: Mon, 05 Feb 2007 15:40:13 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20] arch M68KNOMMU: user ARRAY_SIZE macro when appropriate
References: <20070205024151.GJ18118@Ahmed>
In-Reply-To: <20070205024151.GJ18118@Ahmed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ahmed,

Ahmed S. Darwish wrote:
> A patch to use ARRAY_SIZE macro already defined in linux/kernel.h
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> Patch isn't compile checked cause I have no M68KNOMMU board at hand.

Compiled and tested on m68knommu, no problems.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg




> diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
> index 9130119..72d3496 100644
> --- a/arch/m68knommu/kernel/ptrace.c
> +++ b/arch/m68knommu/kernel/ptrace.c
> @@ -62,7 +62,7 @@ static inline long get_reg(struct task_struct *task, int regno)
>  
>  	if (regno == PT_USP)
>  		addr = &task->thread.usp;
> -	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
> +	else if (regno < ARRAY_SIZE(regoff))
>  		addr = (unsigned long *)(task->thread.esp0 + regoff[regno]);
>  	else
>  		return 0;
> @@ -79,7 +79,7 @@ static inline int put_reg(struct task_struct *task, int regno,
>  
>  	if (regno == PT_USP)
>  		addr = &task->thread.usp;
> -	else if (regno < sizeof(regoff)/sizeof(regoff[0]))
> +	else if (regno < ARRAY_SIZE(regoff))
>  		addr = (unsigned long *) (task->thread.esp0 + regoff[regno]);
>  	else
>  		return -1;
> diff --git a/arch/m68knommu/kernel/traps.c b/arch/m68knommu/kernel/traps.c
> index 9129b3a..bed5f47 100644
> --- a/arch/m68knommu/kernel/traps.c
> +++ b/arch/m68knommu/kernel/traps.c
> @@ -158,7 +158,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
>  void bad_super_trap(struct frame *fp)
>  {
>  	console_verbose();
> -	if (fp->ptregs.vector < 4*sizeof(vec_names)/sizeof(vec_names[0]))
> +	if (fp->ptregs.vector < 4 * ARRAY_SIZE(vec_names))
>  		printk (KERN_WARNING "*** %s ***   FORMAT=%X\n",
>  			vec_names[(fp->ptregs.vector) >> 2],
>  			fp->ptregs.format);
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
