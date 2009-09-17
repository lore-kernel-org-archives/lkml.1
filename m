Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZIQTeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZIQTeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 15:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZIQTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 15:34:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:44178 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZIQTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:34:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SZmDF57d6QV0SJvSmNgAoT61MrOfBFhWKgPi1DxQvTQI9EOV5Kz5Bo5ZrMace7oBRA
         8FkSZd78yOaHZwQ1o9HitXai3nQfNKoFgd1ttglcTaURiLULoCdYt9fm0O7L3JwrYBUF
         CeBxUjng1qaACTV11neXWAE++xoORc0zTN0vA=
Date: Thu, 17 Sep 2009 23:34:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: test for "spurious" IRQ ignores possible IRQ_WAKE_THREAD value
Message-ID: <20090917193416.GE8817@lenovo>
References: <alpine.LFD.2.00.0909141627500.4124@localhost> <alpine.LFD.2.00.0909141632390.4329@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909141632390.4329@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Robert P. J. Day - Mon, Sep 14, 2009 at 04:34:48PM -0400]
| On Mon, 14 Sep 2009, Robert P. J. Day wrote:
| 
| >   never ashamed to embarrass myself in public, i just noticed the
| > following.  from kernel/irq/spurious.c:
| >
| > ...
| > static void
| > __report_bad_irq(unsigned int irq, struct irq_desc *desc,
| >                  irqreturn_t action_ret)
| > {
| >         struct irqaction *action;
| >
| >         if (action_ret != IRQ_HANDLED && action_ret != IRQ_NONE) {
| >                 printk(KERN_ERR "irq event %d: bogus return value %x\n",
| >                                 irq, action_ret);
| >
| >   but from include/linux/irqreturn.h, we see *three* possible return
| > values:
| >
| > enum irqreturn {
| >         IRQ_NONE,
| >         IRQ_HANDLED,
| >         IRQ_WAKE_THREAD,
| > };
| >
| > typedef enum irqreturn irqreturn_t;
| > #define IRQ_RETVAL(x)   ((x) != IRQ_NONE)
| >
| >   is there an inconsistency here?
| 
...

Hi Robert,

It could that IRQ_WAKE_THREAD is just missed here. I suppose it
was brough there as thread irq merged. But I think only Thomas
know for sure, I definitely miss something :) CC'ed
 
	-- Cyrill
