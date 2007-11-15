Return-Path: <linux-kernel-owner+w=401wt.eu-S1765326AbXKOTav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765326AbXKOTav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 14:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbXKOTan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 14:30:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:10535 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXKOTam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 14:30:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=JuKHXIMGboYAVclu61U2geZzcCc4IyubVlcvERCF86T7nxNMd0L2JBI7xZycEUK29ft14pO8V1tERArpWhnXr7hZ2SQBrRMdZ7WKP03dPy2m34uowawojpGWYRUYYrA+b3JNDBrEsnNslsC33gh81uIYo5E5Ic0RoV95+FaUmH4=
Date: Thu, 15 Nov 2007 20:29:47 +0100
From: Frederik Deweerdt <deweerdt@free.fr>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, torvalds@linux-foundation.org
Subject: Re: [PATCHv2 2/4] x86&x86-64 support for sys_indirect
Message-ID: <20071115192947.GF1299@slug>
References: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711151822.lAFIMVvW028590@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ulrich,
On Thu, Nov 15, 2007 at 01:22:31PM -0500, Ulrich Drepper wrote:
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ee800e7..e4e8a22 100644
> --- /dev/null	2007-09-23 16:36:38.465394704 -0700
> +++ b/include/asm-x86/indirect_32.h	2007-11-15 09:52:47.000000000 -0800
[...]
> +#define INDIRECT_SYSCALL(regs) (regs)->eax 
                                        ^^^^^
> +
> +#define CALL_INDIRECT(regs) \
> +  ({ extern long (*sys_call_table[]) (__u32, __u32, __u32, __u32, __u32, __u32); \
> +     sys_call_table[INDIRECT_SYSCALL(regs)->eax] ((regs)->ebx, (regs)->ecx, \
                                             ^^^^^-> I take it that ->eax is wrong here? 
> +						  (regs)->edx, (regs)->esi, \
> +						  (regs)->edi, (regs)->ebp); \
> +     })
> +
> +#endif

Regards,
Frederik
