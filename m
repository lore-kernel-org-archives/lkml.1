Return-Path: <linux-kernel-owner+w=401wt.eu-S934777AbYBUQEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934777AbYBUQEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933383AbYBUQEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:04:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:6958 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763874AbYBUQEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:04:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=KsKbY/q7lblv7bpGNEuwd3X7XihsE234OWXvWuho9fdsPNdkDebZ/j0/xiqiHSW17v31B/oXESJyIHOh20jr1EXOQi6ZXwCRToTAXvvtRgC1h/ylgidijako9SjvrnM1WB32LD7Jv7+aMR6exch3EMBJrhbbsW0yMMJ6WgGWyZU=
Message-ID: <caf255910802210804u1ca0558u8b228a075627b4a5@mail.gmail.com>
Date: Thu, 21 Feb 2008 17:04:04 +0100
From: Pioz <pioz84@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Keyboard interrupt - request_irq()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
  I have a problem.
I want handle the keyboard interrupt and for this purpose I have write
this module (I have kernel 2.6.23):


#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/interrupt.h>

[...]

irqreturn_t
irq_myhandler (int irqn, void *dev)
{
        printk (KERN_INFO "Key pressed...\n");
        return IRQ_HANDLED;
}

int
init_module ()
{
        int res;
        printk (KERN_INFO "Hello World!\n");
        free_irq (1, NULL);
        res = request_irq (1, irq_myhandler, IRQF_SHARED, "bao", dev_id);
        printk (KERN_INFO "res: %d\n", res);
        return 0;
}

void
cleanup_module ()
{
        free_irq (1, NULL);
        printk (KERN_INFO "Goodbye World!\n");
}


The return value of request_irq() function is -EBUSY. Why? Is the
default handler? How can I do to change handler with my function?
Thanks...
