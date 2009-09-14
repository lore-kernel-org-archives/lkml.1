Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbZINUae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbZINUae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933864AbZINUae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:30:34 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38718 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933842AbZINUad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:30:33 -0400
Date: Mon, 14 Sep 2009 16:30:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: test for "spurious" IRQ ignores possible IRQ_WAKE_THREAD value
Message-ID: <alpine.LFD.2.00.0909141627500.4124@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  never ashamed to embarrass myself in public, i just noticed the
following.  from kernel/irq/spurious.c:

...
static void
__report_bad_irq(unsigned int irq, struct irq_desc *desc,
                 irqreturn_t action_ret)
{
        struct irqaction *action;

        if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
                printk(KERN_ERR "irq event %d: bogus return value %x\n",
                                irq, action_ret);

  but from include/linux/irqreturn.h, we see *three* possible return
values:

enum irqreturn {
        IRQ_NONE,
        IRQ_HANDLED,
        IRQ_WAKE_THREAD,
};

typedef enum irqreturn irqreturn_t;
#define IRQ_RETVAL(x)   ((x) != IRQ_NONE)

  is there an inconsistency here?

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
