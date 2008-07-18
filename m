Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbYGRXMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbYGRXMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYGRXMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:12:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbYGRXMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:12:42 -0400
Message-ID: <48812297.5060300@zytor.com>
Date: Fri, 18 Jul 2008 16:09:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386/xen: add proper unwind annotations to	xen_sysenter_target
References: <4880A977.76E4.0078.0@novell.com>
In-Reply-To: <4880A977.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> ---
>  arch/x86/kernel/entry_32.S |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-2.6.26/arch/x86/kernel/entry_32.S	2008-07-13 23:51:29.000000000 +0200
> +++ 2.6.26-i386-xen-entry-annot/arch/x86/kernel/entry_32.S	2008-07-15 14:51:28.000000000 +0200
> @@ -1023,7 +1023,9 @@ ENDPROC(kernel_thread_helper)
>  ENTRY(xen_sysenter_target)
>  	RING0_INT_FRAME
>  	addl $5*4, %esp		/* remove xen-provided frame */
> +	CFI_ADJUST_CFA_OFFSET -5*4
>  	jmp sysenter_past_esp
> +	CFI_ENDPROC
>  
>  ENTRY(xen_hypervisor_callback)
>  	CFI_STARTPROC
> 

Manually applied to x86/xen; CFI_ENDPROC was already in the tree...

	-hpa
