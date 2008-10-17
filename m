Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYJQLap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYJQLap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 07:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYJQLah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 07:30:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:57463 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYJQLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 07:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DsQ12SqyRoZdreOAWgQorhBZRjYnkeK95skKQQEb9QXNaloD2jk+BWzNrfPdoWv80P
         w5FGeLiKgcrkmGpkZk9ArlXZabYS6U9xoGuLggDzv0flUX+96ymiEqeLsZ8OXPoZXvkK
         3t0OIlNoQaDpy6Y7EampbhmOzj+lYAVbzfMTU=
Date: Fri, 17 Oct 2008 12:30:10 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jianjun Kong <jianjun@zeuux.org>
Cc: mingo@elte.hu, Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/x86: Fix waring when build on x86_32
Message-ID: <20081017113010.GD2951@hack.voiplan.pt>
References: <20081017111829.GA20328@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017111829.GA20328@ubuntu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 07:18:29PM +0800, Jianjun Kong wrote:
>
>Fix the waring When I buile the Linux-2.6 kernel on x86_32.
>arch/x86/kernel/io_apic_32.c: In function 'print_local_APIC':
>arch/x86/kernel/io_apic_32.c:1539: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
>arch/x86/kernel/io_apic_32.c:1540: warning: format '%08x' expects type 'unsigned int', but argument 2 has type 'u64'
>
>Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
>---
> arch/x86/kernel/io_apic_32.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
>index e710289..f678d12 100644
>--- a/arch/x86/kernel/io_apic_32.c
>+++ b/arch/x86/kernel/io_apic_32.c
>@@ -1536,8 +1536,8 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
> 	}
> 
> 	icr = apic_icr_read();
>-	printk(KERN_DEBUG "... APIC ICR: %08x\n", icr);
>-	printk(KERN_DEBUG "... APIC ICR2: %08x\n", icr >> 32);
>+	printk(KERN_DEBUG "... APIC ICR: %08x\n", (unsigned int)icr);
>+	printk(KERN_DEBUG "... APIC ICR2: %08x\n", (unsigned int)(icr >> 32));
> 

http://lkml.org/lkml/2008/8/19/566
http://lkml.org/lkml/2008/8/20/119


-- 
"Sometimes the only way to stay sane is to go a little crazy."

