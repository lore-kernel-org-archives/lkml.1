Return-Path: <linux-kernel-owner+w=401wt.eu-S935117AbZDIPIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935117AbZDIPIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934647AbZDIPI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:08:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:57230 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934576AbZDIPI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:08:28 -0400
Subject: Re: [patch 11/13] ioapic: Fix non atomic allocation with
 interrupts disabled
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090317001321.260428000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
	 <20090317001321.260428000@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 20:38:12 +0530
Message-Id: <1239289692.3296.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Suresh,

I am getting sparse warning from this patch.
If possible, please run sparse before sending the patches.


On Mon, 2009-03-16 at 17:05 -0700, Suresh Siddha wrote:
> plain text document attachment (fix_kmalloc_with_irqs_disabled.patch)
> save_mask_IO_APIC_setup() was using non atomic memory allocation while getting
> called with interrupts disabled. Fix this by splitting this into two different
> function. Allocation part save_IO_APIC_setup() now happens before
> disabling interrupts.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
> 
> Index: tip/arch/x86/kernel/apic/io_apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/io_apic.c
> +++ tip/arch/x86/kernel/apic/io_apic.c
> @@ -902,6 +895,25 @@ nomem:
>  	return -ENOMEM;
>  }
>  
> +void mask_IO_APIC_setup(void)
> +{
> +	int apic, pin;
> +

arch/x86/kernel/apic/io_apic.c:806:6: warning: symbol 'apic' shadows an earlier one
  arch/x86/include/asm/apic.h:352:20: originally declared here

Don't worry you are not alone ;-)

  CHECK   arch/x86/kernel/apic/io_apic.c
arch/x86/kernel/apic/io_apic.c:544:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:806:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:994:7: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:1012:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:1440:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:1700:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:1994:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here
arch/x86/kernel/apic/io_apic.c:2781:6: warning: symbol 'apic' shadows an earlier one
 arch/x86/include/asm/apic.h:352:20: originally declared here

Ingo:
don't you think struct apic *apic is very common name can we find some better name.

--
JSR


