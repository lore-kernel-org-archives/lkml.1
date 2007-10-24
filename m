Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbXJXG3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbXJXG3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbXJXG3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:29:34 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51394 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbXJXG3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:29:33 -0400
Date: Wed, 24 Oct 2007 11:59:33 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: hbabu@us.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/3] x86: add lapic_shutdown for x86_64
Message-ID: <20071024062933.GA4622@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <47195763.1090803@ct.jp.nec.com> <47195807.6030809@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47195807.6030809@ct.jp.nec.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 06:21:11PM -0700, Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/kernel/apic_64.c |   14 ++++++++++++++
>  include/asm-x86/apic_64.h |    1 +
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
> index f47bc49..f28ccb5 100644
> --- a/arch/x86/kernel/apic_64.c
> +++ b/arch/x86/kernel/apic_64.c
> @@ -287,6 +287,20 @@ void disable_local_APIC(void)
>  	apic_write(APIC_SPIV, value);
>  }
> 
> +void lapic_shutdown(void)
> +{
> +	unsigned long flags;
> +
> +	if (!cpu_has_apic)
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	disable_local_APIC();
> +
> +	local_irq_restore(flags);
> +}
> +
>  /*

Do we really have to introduce this function for 64bit? I remember some
issues were faced on i386 w.r.t kernel enabling the LAPIC against the
wishes of BIOS hence kernel was disabling it while shutting down. No
such problems were reported for x86_64 hence this function existed only
for i386.

If that is the case, probably we don't have to introduce lapic_shutdown()
for x86_64. Instead call lapic_shutdown() for X86_32, and disble_local_APIC()
otherwise?

Thanks
Vivek
