Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZKUKaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZKUKaY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 05:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbZKUKaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 05:30:24 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:61938 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbZKUKaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 05:30:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ViKQs+GKWm7cSH3fAziiRQ/gvLfgpU3dDB4HVv+c8MWR+vMz+CrVUEZWlF97WxZNqp
         LQ5xpT1JRQIJxEnC+vVb9JWra9u+pd0FxJdk5wB19zB4kGcPDGd9z0rcgXRI+djB++3o
         5UBhirfCPIfJuFQxjXunm3iZRebT9rcF9ZJeU=
Date: Sat, 21 Nov 2009 18:31:04 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: suppress stack overrun message for init_task
Message-ID: <20091121103104.GD2412@hack>
References: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B06AEFE02000078000211F4@vpn.id2.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 02:00:14PM +0000, Jan Beulich wrote:
>init_task doesn't get its stack end location set to STACK_END_MAGIC,
>and hence the message is confusing rather than helpful in this case.
>
>Signed-off-by: Jan Beulich <jbeulich@novell.com>
>

How about the patch below? It is totally untested. ;)

-------------->

init process should also write STACK_END_MAGIC to the
end of its stack.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

----
diff --git a/init/main.c b/init/main.c
index 5988deb..5a8f1b9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -69,6 +69,7 @@
 #include <linux/kmemtrace.h>
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
+#include <linux/magic.h>
 #include <trace/boot.h>
 
 #include <asm/io.h>
@@ -798,7 +799,9 @@ static void __init do_pre_smp_initcalls(void)
 
 static void run_init_process(char *init_filename)
 {
+	unsigned long *stack_end = end_of_stack(&init_task);
 	argv_init[0] = init_filename;
+	*stack_end = STACK_END_MAGIC;
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
