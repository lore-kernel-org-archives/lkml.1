Return-Path: <linux-kernel-owner+w=401wt.eu-S1755946AbZKWIlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbZKWIlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZKWIlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:41:31 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:15376 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZKWIlb (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Mon, 23 Nov 2009 03:41:31 -0500
Message-Id: <4B0A58CC02000078000215CB@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 23 Nov 2009 08:41:32 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "=?UTF-8?Q?Am=C3=A9ricoWang?=" <xiyou.wangcong@gmail.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: suppress stack overrun message for init_task
References: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
 <20091121103104.GD2412@hack>
In-Reply-To: <20091121103104.GD2412@hack>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> AméricoWang <xiyou.wangcong@gmail.com> 21.11.09 11:31 >>>
>On Fri, Nov 20, 2009 at 02:00:14PM +0000, Jan Beulich wrote:
>>init_task doesn't get its stack end location set to STACK_END_MAGIC,
>>and hence the message is confusing rather than helpful in this case.
>>
>>Signed-off-by: Jan Beulich <jbeulich@novell.com>
>>
>
>How about the patch below? It is totally untested. ;)
>
>-------------->
>
>init process should also write STACK_END_MAGIC to the
>end of its stack.

This seems way too late to me - in order to avoid any false reports, it
would really need to be part of INIT_TASK() I believe, but I didn't find
a way to make it so.

Jan

>Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
>
>----
>diff --git a/init/main.c b/init/main.c
>index 5988deb..5a8f1b9 100644
>--- a/init/main.c
>+++ b/init/main.c
>@@ -69,6 +69,7 @@
> #include <linux/kmemtrace.h>
> #include <linux/sfi.h>
> #include <linux/shmem_fs.h>
>+#include <linux/magic.h>
> #include <trace/boot.h>
> 
> #include <asm/io.h>
>@@ -798,7 +799,9 @@ static void __init do_pre_smp_initcalls(void)
> 
> static void run_init_process(char *init_filename)
> {
>+	unsigned long *stack_end = end_of_stack(&init_task);
> 	argv_init[0] = init_filename;
>+	*stack_end = STACK_END_MAGIC;
> 	kernel_execve(init_filename, argv_init, envp_init);
> }
 
