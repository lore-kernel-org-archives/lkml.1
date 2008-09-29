Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbYI2Rq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbYI2Rq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYI2RqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 13:46:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:16170 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYI2RqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 13:46:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,333,1220252400"; 
   d="scan'208";a="52807317"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Mon, 29 Sep 2008 10:45:58 -0700
Subject: RE: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Thread-Topic: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Thread-Index: Acke1jJNuz0EHIYrQuKKWuO1dm0WtwDhL5fA
Message-ID: <7E82351C108FA840AB1866AC776AEC46315235C7@orsmsx505.amr.corp.intel.com>
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
In-Reply-To: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doesn't look like this patch is doing anything with respect to "hpet compiling".
It is just adding some debug prints. I guess we need a better patch description.

Thanks,
Venki

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Yinghai Lu
>Sent: Wednesday, September 24, 2008 11:14 PM
>To: Jesse Barnes; Len Brown; Ingo Molnar; Thomas Gleixner; H.
>Peter Anvin; Andrew Morton
>Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org;
>linux-acpi@vger.kernel.org; Yinghai Lu
>Subject: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
>
>v2: fix hpet compiling
>
>Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>


Doesn't look like the patch below is doing anything with respect to "hpet compiling".
It is just adding some debug prints. I guess we need a different patch description.

Thanks,
Venki


>---
> arch/x86/kernel/hpet.c    |    3 +++
> arch/x86/kernel/io_apic.c |    7 +++++++
> 2 files changed, 10 insertions(+), 0 deletions(-)
>
>diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
>index 422c577..686505a 100644
>--- a/arch/x86/kernel/hpet.c
>+++ b/arch/x86/kernel/hpet.c
>@@ -467,6 +467,9 @@ static int hpet_setup_irq(struct hpet_dev *dev)
>        irq_set_affinity(dev->irq, cpumask_of_cpu(dev->cpu));
>        enable_irq(dev->irq);
>
>+       printk(KERN_DEBUG "hpet: %s is using irq %#x aka %d for MSI\n",
>+                        dev->name, dev->irq, dev->irq);
>+
>        return 0;
> }
>
>diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
>index 4cc9cb6..dc82397 100644
>--- a/arch/x86/kernel/io_apic.c
>+++ b/arch/x86/kernel/io_apic.c
>@@ -3355,6 +3355,9 @@ static int setup_msi_irq(struct pci_dev
>*dev, struct msi_desc *desc, int irq)
> #endif
>                set_irq_chip_and_handler_name(irq, &msi_chip,
>handle_edge_irq, "edge");
>
>+       printk(KERN_DEBUG "PCI: %s is using irq %#x aka %d for
>MSI/MSI-X\n",
>+                        pci_name(dev), irq, irq);
>+
>        return 0;
> }
>
>@@ -3587,6 +3590,7 @@ int arch_setup_hpet_msi(unsigned int irq)
>        hpet_msi_write(irq, &msg);
>        set_irq_chip_and_handler_name(irq, &hpet_msi_type,
>handle_edge_irq,
>                "edge");
>+
>        return 0;
> }
> #endif
>@@ -3683,6 +3687,9 @@ int arch_setup_ht_irq(unsigned int irq,
>struct pci_dev *dev)
>
>                set_irq_chip_and_handler_name(irq, &ht_irq_chip,
>                                              handle_edge_irq, "edge");
>+
>+               printk(KERN_DEBUG "PCI: %s is using irq %#x
>aka %d for HT\n",
>+                                pci_name(dev), irq, irq);
>        }
>        return err;
> }
>--
>1.5.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe
>linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
