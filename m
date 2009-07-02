Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZGBRkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZGBRkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbZGBRk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:40:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3556 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbZGBRk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:40:26 -0400
Subject: Re: printk regression?
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 10:38:40 -0700
Message-Id: <1246556320.28915.92.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-02 at 10:27 -0700, Linus Torvalds wrote:
> Of course, some cases are just crazy. Here's one:
> 
> 	arch/m68knommu/kernel/traps.c:          printk(KERN_CONT "\n" KERN_EMERG " [%08lx] ", addr);
> 
> and I have no clue about why it would have KERN_CONT there.

Generally, it's because hardware is being scanned in little
bits and pieces with partial line printk's being used to
document things "as it happens".

If something odd happens, the "in-progress" printk's are
terminated and another "whoa nellie" printk is done.

There's a bunch of that in drivers/net.

>  That makes 
> little sense. Again, with the new printk logic, it really should be just
> 
> 	printk(KERN_EMERG " [%08lx] ", addr);
> 
> and nothing odd.

Maybe, but your printk change does require that all of
the kernel sources be updated as necessary.

