Return-Path: <linux-kernel-owner+w=401wt.eu-S1753035AbZGBRpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbZGBRpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGBRoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:44:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751094AbZGBRoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:44:54 -0400
Date: Thu, 2 Jul 2009 10:42:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: lkml@morethan.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: printk regression?
In-Reply-To: <1246548556.28915.80.camel@Joe-Laptop.home>
Message-ID: <alpine.LFD.2.01.0907021039320.4830@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>  <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>  <1246513356.28915.62.camel@Joe-Laptop.home>  <200907020729.23976.lkml@morethan.org> <1246548556.28915.80.camel@Joe-Laptop.home>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Jul 2009, Joe Perches wrote:
> 
> Before some changes to the printk code, that used to
> be the only way to get a single printk call with multiple
> line output to have a KERN_<level> on all output lines.
> 
> ie:	printk(KERN_INFO "Line 1\n" KERN_INFO "Line 2\n");
> 
> That style doesn't show up in the grep I posted because most
> of them look like:
> 
> 	printk(KERN_INFO "Line 1\n"
> 	       KERN_INFO "Line 2\n");
> 
> An example:  here's a bit of kernel/module.c:
> 
> 		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
> 				    "it should follow 0/-E convention\n"
> 		       KERN_WARNING "%s: loading module anyway...\n",

Yeah. Today, the way you're supposed to do that is simply

	printk(KERN_WARNING
		"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
		"%s: loading module anyway...\n",  
		...

because the KERN_WARNING will cover the whole multi-line printk.

And if you want multiple _different_ loglevels (which is crazy - if you 
really want this, then you should look at your walls and double-check that 
they are nice and softly padded), you need to split it up into multiple 
printk's.

			Linus
