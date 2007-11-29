Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbXK2K0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbXK2K0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbXK2K0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:26:15 -0500
Received: from alephnull.demon.nl ([83.160.184.112]:56829 "EHLO
	xi.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbXK2K0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:26:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=1148133259;
	d=wantstofly.org;
	h=date:from:to:cc:subject:message-id:mime-version:content-type:
	content-disposition:in-reply-to:user-agent;
	b=G1Ofx/sYJ1gMSOwDfPV3EKEio6XtWOrlex+cRZxQVdVVfcDU5rQXN96ry9f3U
	v2zoDgJefIS8Bl6RE2lD5EipQ==
Date: Thu, 29 Nov 2007 11:26:11 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, kernel@wantstofly.org
Subject: Re: [PATCH] asm-arm/{arch-omap,arch-ixp23xx}: parentheses around NR_IRQS definition
Message-ID: <20071129102611.GB3959@xi.wantstofly.org>
References: <474E10BA.8020704@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474E10BA.8020704@tiscali.nl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 02:07:06AM +0100, Roel Kluin wrote:

> in include/asm-arm/arch-omap/board-innovator.h:40
> #define NR_IRQS    IH_BOARD_BASE + NR_FPGA_IRQS
> 
> in include/asm-arm/arch-ixp23xx/irqs.h:156:
> #define NR_IRQS      NR_IXP23XX_IRQS + NR_IXP23XX_MACH_IRQS
> 
> This could lead to problems when this definition is used in:
> 
> arch/ia64/sn/kernel/irq.c:516:
> sn_irq_lh = kmalloc(sizeof(struct list_head *) * NR_IRQS, GFP_KERNEL);
> arch/x86/kernel/io_apic_32.c:693:
> irq_cpu_data[i].irq_delta = kmalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
> 694:
> irq_cpu_data[i].last_irq = kmalloc(sizeof(unsigned long) * NR_IRQS, GFP_KERNEL);
> 699:
> memset(irq_cpu_data[i].irq_delta,0,sizeof(unsigned long) * NR_IRQS);
> 700:
> memset(irq_cpu_data[i].last_irq,0,sizeof(unsigned long) * NR_IRQS);
> fs/proc/proc_misc.c:464:
> per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
> 
> I am not sure whether this definition actually is used in any of these files.
> Am I being paranoya? anyway, adding parentheses should be safe.
> --
> Add parentheses to prevent operator precedence errors
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>

Please send to the ARM patch system.
