Return-Path: <linux-kernel-owner+w=401wt.eu-S935670AbYEVWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935670AbYEVWAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935129AbYEVWAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:00:25 -0400
Received: from www.tglx.de ([62.245.132.106]:54012 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934928AbYEVWAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:00:23 -0400
Date: Fri, 23 May 2008 00:00:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: move mp_bus_not_pci from mpparse.c
In-Reply-To: <20080519154715.15071.44328.stgit@thinkpad>
Message-ID: <alpine.LFD.1.10.0805222351400.3295@apollo.tec.linutronix.de>
References: <20080519154656.15071.96979.stgit@thinkpad> <20080519154715.15071.44328.stgit@thinkpad>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Alexey Starikovskiy wrote:

> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -81,6 +81,12 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
>  /* # of MP IRQ source entries */
>  int mp_irq_entries;
>  
> +#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
> +int mp_bus_id_to_type[MAX_MP_BUSSES];
> +#endif
> +
> +DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
> +

> +++ b/arch/x86/kernel/io_apic_64.c
> @@ -117,6 +117,8 @@ struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
>  /* # of MP IRQ source entries */
>  int mp_irq_entries;
>  
> +DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
> +

NAK for the whole series. If you want to move out stuff from mpparse,
then please look for a useful place, which is

1) related to the code (mp_bus_not_pci has no obvious association to
io_apic)

2) not duplicating code into 32/64 bit files again. We work hard on
unifying and also distangling things and I refuse to accept a patch
which moves code to a random place where it happens to compile.

Thanks,

	tglx
