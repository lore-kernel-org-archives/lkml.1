Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbXIUMpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbXIUMpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbXIUMpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:45:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:23110 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXIUMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zn8iYf9gMxelF9Fy3zewASOeiqiB9TAZE3nNQfFwCMtiW+YvissxpZl1mlbWuf165iqK3GTFZRNRi90deb/L49uuxxcdTtCLHrh8uilCR4viskHobQU/eQP3x2WDuFCoiVBvLY2fsXkNJHJIjoVAtTMpXoZeJCSVTE6V0CBu9YU=
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
From: Gilboa Davara <gilboad@gmail.com>
Reply-To: gilboad@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <46F1314B.8040105@grupopie.com>
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>
	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>
	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>
	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>
	 <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>
	 <46F1314B.8040105@grupopie.com>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 14:45:37 +0200
Message-Id: <1190378737.30016.15.camel@gilboa-home-dev.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paulo,

[snip]
> I must say I agree with Satyam here.
> 
> Locking in the panic path might leave us without some critical debug 
> information, which is much more important than all this.
> 
> Maybe it would be better to change the print_symbol interface to avoid 
> having a "char buffer[KSYM_SYMBOL_LEN];" at all.
> 
> Most print_symbol callers use something like "yada yada %s" as the 
> format string, with an optional "\n" in the end.
> 
> if we change the interface from "print_symbol(fmt, addr)" to 
> "print_symbol(prefix, addr, int newline)" we can simply do:
> 
> printk(prefix);
> printk_symbol(addr);
> if (newline)
> 	printk("\n");
> 
> where "printk_symbol" is a new function that does the same as 
> sprint_symbol, but does "printk" instead of "sprintf".
> 
> This should reduce immensely the stack usage of print_symbol without the 
> need for locking.

I fully agree.
... Further more, multiple printk_symbols should be combined into a
single, multi-line printk transaction. (To prevent debug printk's from
trashing a BUG() dump_stack). 

> 
> Of course this requires changing _all_ callers of print_symbol to use 
> the new interface, but these are less than 100 ;)

This is my first contribution to the Linux kernel. As such I rather
start small, and work my way up slowly. (Read: solve the immediate stack
over-run now, think about changing the symbol_display interface later)

> 
> Comments?

I do agree that the current interface needs work.

... But as I said, I rather start slowly and on small scale. (Though I
did find a rather problematic place to start at... ;))

- Gilboa

