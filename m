Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477Ab0A0PYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0A0PYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995Ab0A0PYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:24:39 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:43141 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0A0PYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:24:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=ABMJx61lMnnr5HDZXd1xhOGi4lYHMx+wQO59cdlwby3DIUvPljBZtfQ5EEjlHI+dgl
         Rv66YMfaBQG7+tTlEX9InHPznYhiXMoa4AzDegze1Qhp58M+H7aoNxtWZY26y7e0zRf0
         p3TRgAjb3BH1LL0ggAC42UkC4yjlHbjGt8MUk=
Subject: Re: [PATCH rt/2.6.31] [RT] kernel/sched.c: Fixup of "implicit
 declaration of function '_finish_arch_switch'"
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4dc11af5f8e10e716e94f4b6b886d1160a5a1744.1264605070.git.wuzhangjin@gmail.com>
References: <4dc11af5f8e10e716e94f4b6b886d1160a5a1744.1264605070.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 27 Jan 2010 23:17:54 +0800
Message-ID: <1264605474.30911.0.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 23:12 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch fixes the following error:
> 
> kernel/sched.c: In function 'finish_task_switch':
> kernel/sched.c:2979: error: implicit declaration of function
> '_finish_arch_switch'
> 
> The following archs have defined their finish_arch_switch:
> 
> $ grep finish_arch_switch -ur arch/
> arch/s390/include/asm/system.h:#define finish_arch_switch(prev)
> arch/sh/include/asm/system_32.h:#define finish_arch_switch(prev
> arch/avr32/include/asm/system.h:#define finish_arch_switch(prev)
> arch/mips/include/asm/system.h:#define finish_arch_switch(prev)
> 
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 590b9bb..739156e 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -959,6 +959,8 @@ static inline u64 global_rt_runtime(void)
>  #endif
>  #ifndef finish_arch_switch
>  # define _finish_arch_switch(prev)	do { } while (0)
> +#else
> +# define _finish_arch_switc		finish_arch_switch

Sorry, Just found the "TAB" delete the "h" of the above
_finish_arch_switc, will resend one later.

Regards,
	Wu Zhangjin

