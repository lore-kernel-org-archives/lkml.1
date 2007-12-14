Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbXLNHIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbXLNHIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXLNHIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:08:46 -0500
Received: from gw.goop.org ([64.81.55.164]:47628 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXLNHIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:08:45 -0500
Message-ID: <47622BEA.9030808@goop.org>
Date: Thu, 13 Dec 2007 23:08:26 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>
Subject: Re: [PATCH] i386: XEN config option should not depend on	X86_TSC/X86_CMPXCHG
References: <476102D1.76E4.0078.0@novell.com>
In-Reply-To: <476102D1.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> The way X86_TSC works and the fact that Xen itself won't work on
> systems without TSC (really any systems pre-dating i686) makes it
> unnecessary for XEN to depend on it.
>
> Similarly, X86_CMPXCHG isn't needed here either as Xen for the above
> reason guarantees its availability.
>
> This allows the option to be available when selecting M386, M486, or
> M586.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
>   

Oh, I thought this had already happened.  Guess not.

Anyway:

Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
>  arch/x86/xen/Kconfig |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.24-rc5/arch/x86/xen/Kconfig	2007-12-12 11:28:18.000000000 +0100
> +++ 2.6.24-rc5-i386-xen-no-tsc/arch/x86/xen/Kconfig	2007-12-07 14:53:28.000000000 +0100
> @@ -5,7 +5,7 @@
>  config XEN
>  	bool "Xen guest support"
>  	select PARAVIRT
> -	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
> +	depends on !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
>  	help
>  	  This is the Linux Xen port.  Enabling this will allow the
>  	  kernel to boot in a paravirtualized environment under the
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

