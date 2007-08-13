Return-Path: <linux-kernel-owner+w=401wt.eu-S966954AbXHMPal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966954AbXHMPal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972991AbXHMN3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:29:48 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1854 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S973102AbXHMN3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:29:46 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: surya.prabhakar@wipro.com
Subject: Re: [KJ] replacing kmalloc with kzalloc in io_apic.c
Date: Mon, 13 Aug 2007 15:18:20 +0200
User-Agent: KMail/1.9.5
Cc: mingo@redhat.com, yaku@css1.kbnes.nec.co.jp, kisimoto@css1.kbnes.nec.co.jp,
       zab@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
References: <1186993881.3175.15.camel@bluegenie>
In-Reply-To: <1186993881.3175.15.camel@bluegenie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131518.20580.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
>    Replacing kmalloc with kzalloc and cleaning up memset in
> arch/i386/kernel/io_apic.c
>
>
> Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
> ---
>
> diff --git a/arch/i386/kernel/io_apic.c b/arch/i386/kernel/io_apic.c
> index 4b8a8da..1329615 100644
> --- a/arch/i386/kernel/io_apic.c
> +++ b/arch/i386/kernel/io_apic.c
> @@ -690,14 +690,12 @@ static int __init balanced_irq_init(void)
>  		physical_balance = 1;
>
>  	for_each_online_cpu(i) {
> -		irq_cpu_data[i].irq_delta = kmalloc(sizeof(unsigned long) * NR_IRQS,
> GFP_KERNEL); -		irq_cpu_data[i].last_irq = kmalloc(sizeof(unsigned long) *
> NR_IRQS, GFP_KERNEL); +		irq_cpu_data[i].irq_delta =
> kzalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
> +		irq_cpu_data[i].last_irq = kzalloc(sizeof(unsigned long) * NR_IRQS,
> GFP_KERNEL); if (irq_cpu_data[i].irq_delta == NULL ||
> irq_cpu_data[i].last_irq == NULL) { printk(KERN_ERR "balanced_irq_init: out
> of memory");
>  			goto failed;
>  		}
> -		memset(irq_cpu_data[i].irq_delta,0,sizeof(unsigned long) * NR_IRQS);
> -		memset(irq_cpu_data[i].last_irq,0,sizeof(unsigned long) * NR_IRQS);
>  	}
>
>  	printk(KERN_INFO "Starting balanced_irq\n");

How about using kcalloc here?

i.e. 
...
... = kcalloc(NR_IRQS, sizeof(unsigned long), GFP_KERNEL);
...

Regards,

	Mariusz
