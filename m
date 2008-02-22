Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbYBVEFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbYBVEFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbYBVEEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:04:55 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:62381 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470AbYBVEEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:04:54 -0500
Date: Thu, 21 Feb 2008 22:04:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Keyboard interrupt - request_irq()
In-reply-to: <fa.Q5fldlauC9khAhVFQXr2Stx54+I@ifi.uio.no>
To: Pioz <pioz84@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47BE49DD.6070404@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Q5fldlauC9khAhVFQXr2Stx54+I@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pioz wrote:
> Hi all,
>   I have a problem.
> I want handle the keyboard interrupt and for this purpose I have write
> this module (I have kernel 2.6.23):
> 
> 
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/interrupt.h>
> 
> [...]
> 
> irqreturn_t
> irq_myhandler (int irqn, void *dev)
> {
>         printk (KERN_INFO "Key pressed...\n");
>         return IRQ_HANDLED;
> }
> 
> int
> init_module ()
> {
>         int res;
>         printk (KERN_INFO "Hello World!\n");
>         free_irq (1, NULL);
>         res = request_irq (1, irq_myhandler, IRQF_SHARED, "bao", dev_id);
>         printk (KERN_INFO "res: %d\n", res);
>         return 0;
> }
> 
> void
> cleanup_module ()
> {
>         free_irq (1, NULL);
>         printk (KERN_INFO "Goodbye World!\n");
> }
> 
> 
> The return value of request_irq() function is -EBUSY. Why? Is the
> default handler? How can I do to change handler with my function?
> Thanks...

Normally one doesn't register multiple interrupt handlers for the same 
device. For a PCI level-triggered interrupt one can do it (for the case 
where multiple devices share the IRQ), but the PC keyboard interrupt is 
edge-triggered and isn't sharable.
