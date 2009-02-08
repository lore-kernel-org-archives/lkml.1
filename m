Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZBHNsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZBHNsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 08:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZBHNsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 08:48:04 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:32895 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZBHNsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 08:48:03 -0500
Date: Sun, 8 Feb 2009 14:47:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <frank@f-seidel.de>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090208144751.46184041@hyperion.delvare>
In-Reply-To: <498EDA18.1090300@f-seidel.de>
References: <498C3EEA.5060508@suse.de>
	<20090208000553.059a0732@hyperion.delvare>
	<498EDA18.1090300@f-seidel.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 14:11:52 +0100, Frank Seidel wrote:
> Hi,
> 
> Jean Delvare wrote:
> >> +	printk(KERN_ERR "i2c: ICR: %08x ISR: %08x\n"
> >>  	       "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
> >>  	for (i = 0; i < i2c->irqlogidx; i++)
> >>  		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
> > 
> > This last printk also lacks a log level. You can't add it in the loop,
> > but you could add one printk before the loop, printing just the log level.
> 
> Isn't the last printk just a followup of the previous KERN_ERR which
> doesn't have a newline? And i'm told only on new line beginnings the
> loglevel should be set.

I mean the (first) printk in the loop, not the last printk in this
function. So what I am suggesting is:

+	printk(KERN_DEBUG);
	for (i = 0; i < i2c->irqlogidx; i++)
		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);
	printk("\n");

-- 
Jean Delvare
