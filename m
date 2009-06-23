Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZFWJGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZFWJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 05:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFWJGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 05:06:36 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:40787 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZFWJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 05:06:36 -0400
Date: Tue, 23 Jun 2009 11:06:14 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [PATCH] cris: use new macros for .data.init_task.
Message-ID: <20090623090614.GZ12383@axis.com>
References: <1241135077-8001-1-git-send-email-tabbott@mit.edu> <1241135077-8001-2-git-send-email-tabbott@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241135077-8001-2-git-send-email-tabbott@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 01:44:37AM +0200, Tim Abbott wrote:
> .data.init_task should not need a separate output section; this change
> moves it into the .data section.

Hi,

Sorry about not picking this up earlier, but what's the status of
the prerequisite macros? From what I can see, the prerequisite for
the first part of the patch is now in mainline, but there seems to
be no users of INIT_TASK_DATA yet.
(And it looks a bit dodgy as it uses INIT_TASK without any argument...)

Should I split up your patch or is there any reason to keep them together?

/Jesper

> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: dev-etrax@axis.com
> ---
>  arch/cris/kernel/process.c     |    3 +--
>  arch/cris/kernel/vmlinux.lds.S |    4 +---
>  2 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
> index 4df0b32..7a270c6 100644
> --- a/arch/cris/kernel/process.c
> +++ b/arch/cris/kernel/process.c
> @@ -49,8 +49,7 @@ EXPORT_SYMBOL(init_mm);
>   * way process stacks are handled. This is done by having a special
>   * "init_task" linker map entry..
>   */
> -union thread_union init_thread_union 
> -	__attribute__((__section__(".data.init_task"))) =
> +union thread_union init_thread_union __init_task_data =
>  		{ INIT_THREAD_INFO(init_task) };
>  
>  /*
> diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
> index 0d2adfc..e4f7490 100644
> --- a/arch/cris/kernel/vmlinux.lds.S
> +++ b/arch/cris/kernel/vmlinux.lds.S
> @@ -62,14 +62,12 @@ SECTIONS
>  	___data_start = . ;
>  	__Sdata = . ;
>  	.data : {			/* Data */
> +		INIT_TASK_DATA(PAGE_SIZE)
>  		DATA_DATA
>  	}
>  	__edata = . ;			/* End of data section. */
>  	_edata = . ;
>  
> -	. = ALIGN(PAGE_SIZE);	/* init_task and stack, must be aligned. */
> -	.data.init_task : { *(.data.init_task) }
> -
>  	. = ALIGN(PAGE_SIZE);		/* Init code and data. */
>  	__init_begin = .;
>  	.init.text : {
> -- 
> 1.6.2.1

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
