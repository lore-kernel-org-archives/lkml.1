Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYHHKOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYHHKOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbYHHKOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:14:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58576 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYHHKOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:14:24 -0400
Subject: Re: [PATCH -v2 6/8] kexec jump: fix for lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <1218178365.22039.79.camel@caritas-dev.intel.com>
References: <1218178365.22039.79.camel@caritas-dev.intel.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 12:13:46 +0200
Message-Id: <1218190426.8625.71.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 14:52 +0800, Huang Ying wrote:
> Replace local_irq_disable() with raw_local_irq_disable() to prevent
> lockdep complain.


Uhhm, please provide more information - just using raw_* to silence
lockdep is generally the wrong thing to do.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/kernel/machine_kexec_32.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -123,7 +123,7 @@ void machine_kexec(struct kimage *image)
>  	tracer_disable();
>  
>  	/* Interrupts aren't acceptable while we reboot */
> -	local_irq_disable();
> +	raw_local_irq_disable();
>  
>  	if (image->preserve_context) {
>  #ifdef CONFIG_X86_IO_APIC
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

