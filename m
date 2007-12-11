Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbXLKAfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbXLKAfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 19:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXLKAe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 19:34:58 -0500
Received: from gw.goop.org ([64.81.55.164]:55666 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbXLKAe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 19:34:57 -0500
Message-ID: <475DDB2F.9060405@goop.org>
Date: Mon, 10 Dec 2007 16:34:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix a few paravirt-related modpost warnings
References: <475D79A4.76E4.0078.0@novell.com>
In-Reply-To: <475D79A4.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>   
Acked-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

>  arch/x86/kernel/head_32.S |    2 +-
>  arch/x86/xen/setup.c      |    2 +-
>  arch/x86/xen/xen-head.S   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> --- linux-2.6.24-rc4/arch/x86/kernel/head_32.S	2007-12-07 09:00:59.000000000 +0100
> +++ 2.6.24-rc4-i386-lguest-warning/arch/x86/kernel/head_32.S	2007-12-05 18:30:33.000000000 +0100
> @@ -151,7 +151,7 @@ WEAK(xen_entry)
>  	/* Unknown implementation; there's really
>  	   nothing we can do at this point. */
>  	ud2a
> -.data
> +.section .init.data, "aw"
>  subarch_entries:
>  	.long default_entry		/* normal x86/PC */
>  	.long lguest_entry		/* lguest hypervisor */
> --- linux-2.6.24-rc4/arch/x86/xen/setup.c	2007-12-07 09:01:00.000000000 +0100
> +++ 2.6.24-rc4-i386-lguest-warning/arch/x86/xen/setup.c	2007-12-10 17:31:06.000000000 +0100
> @@ -59,7 +59,7 @@ static void xen_idle(void)
>  /*
>   * Set the bit indicating "nosegneg" library variants should be used.
>   */
> -static void fiddle_vdso(void)
> +static __init void fiddle_vdso(void)
>  {
>  	extern u32 VDSO_NOTE_MASK; /* See ../kernel/vsyscall-note.S.  */
>  	extern char vsyscall_int80_start;
> --- linux-2.6.24-rc4/arch/x86/xen/xen-head.S	2007-12-07 09:01:00.000000000 +0100
> +++ 2.6.24-rc4-i386-lguest-warning/arch/x86/xen/xen-head.S	2007-12-10 17:25:46.000000000 +0100
> @@ -7,7 +7,7 @@
>  #include <asm/boot.h>
>  #include <xen/interface/elfnote.h>
>  
> -.pushsection .init.text
> +.pushsection .init.text, "ax"
>  ENTRY(startup_xen)
>  	movl %esi,xen_start_info
>  	cld
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

