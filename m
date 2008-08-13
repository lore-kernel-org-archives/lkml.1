Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYHMBvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYHMBvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYHMBvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:51:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:12859 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbYHMBvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:51:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,199,1217833200"; 
   d="scan'208";a="606295617"
Subject: Re: Panic on boot for x86_64
From: Zhao Yakui <yakui.zhao@intel.com>
To: Martin Bligh <mbligh@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <33307c790808121647j4feef841i23638dba40197648@mail.gmail.com>
References: <33307c790808121251t79af0fajf44cebffa8938051@mail.gmail.com>
	 <20080812131045.b89e98b1.akpm@linux-foundation.org>
	 <86802c440808121313x26e46c00m9ec6cd73b3bdbf22@mail.gmail.com>
	 <200808122223.29022.rjw@sisk.pl>
	 <33307c790808121647j4feef841i23638dba40197648@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 10:05:27 +0800
Message-Id: <1218593127.3998.51.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 16:47 -0700, Martin Bligh wrote:
> >> please try tip/master, or wait a while after linus pull fix from tip x86 fix.
> >
> > The fix is in the mainline already.
> 
> 
> Still looks broken to me (rc2-git5)
> 
> http://test.kernel.org/results/IBM/188946/debug/console
> 
> It got in since yesterday?

>From the dmesg of 2.6.16 there exists the following info.
    >ACPI: PCI Interrupt 0000:2b:01.0[A] -> GSI 240 (level, low) -> IRQ
66
    ACPI: PCI Interrupt 0000:2b:01.1[B] -> GSI 244 (level, low) -> IRQ
74
   The GSI number for 0000:2b.01.0 pci device is 240.
   The GSI number for 0000:2b.01.1 pci device is 244.   

   In the function of add_pin_to_irq (in io_apic_64.c) there exists the
following checks.
         > BUG_ON(irq >= NR_IRQS);
   
   On the 2.6.16 kernel OS will map a GSI number to a different IRQ
below NR_IRQS(this macro definition is 224). So there is no problem.
  
But on the x86_64 platform of 2.6.26 kernel OS will treat the GSI number
as the IRQ number. As the GSI number for 00:2b.01.0 pci device is above
224, it will print the kernel panic info. 
   
   From the test log it seems that this issue is related with the GSI
mapping mechanism. Maybe it will be OK to use the same GSI mapping
mechanism as x86_32 platform. 

Thanks.
   Yakui

> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

