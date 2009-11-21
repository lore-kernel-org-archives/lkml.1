Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZKUKVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZKUKVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 05:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZKUKVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 05:21:22 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65390 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZKUKVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 05:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hc9qTKCOicRU3SD0K752BqAgkrI1wRoEms9Wc0tfhK8ua2+DIAdSH78PThsFS5ngY/
         8BNf25OVoi1cBrM1HLmPxlhLXzRvfa0rJO0VReUP5JGjjGuaCruC8RBB0Ygkz+e0Bc4v
         5urOjRB3C2dP7hV1lWhsw198pcSIgbPjmRC2o=
Date: Sat, 21 Nov 2009 18:17:09 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: suppress stack overrun message for init_task
Message-ID: <20091121101709.GC2412@hack>
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

Yeah, this is a good catch. STACK_END_MAGIC is written in fork(),
init is not forked.

However, isn't it better if we can do the same detection
for init too?


>---
> arch/x86/mm/fault.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>--- linux-2.6.32-rc8/arch/x86/mm/fault.c
>+++ 2.6.32-rc8-x86-init-task-stack/arch/x86/mm/fault.c
>@@ -658,7 +658,7 @@ no_context(struct pt_regs *regs, unsigne
> 	show_fault_oops(regs, error_code, address);
> 
> 	stackend = end_of_stack(tsk);
>-	if (*stackend != STACK_END_MAGIC)
>+	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
> 		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");
> 
> 	tsk->thread.cr2		= address;
>
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
