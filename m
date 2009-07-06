Return-Path: <linux-kernel-owner+w=401wt.eu-S1755315AbZGFUgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbZGFUgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbZGFUgC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:36:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754353AbZGFUgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:36:02 -0400
Date: Mon, 6 Jul 2009 13:33:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Joe Perches <joe@perches.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove multiple KERN_ prefixes from printk formats
In-Reply-To: <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>  <1246513356.28915.62.camel@Joe-Laptop.home> <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>  <1246556320.28915.92.camel@Joe-Laptop.home>
 <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>  <1246910740.4643.10.camel@Joe-Laptop.home> <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Jul 2009, Mike Frysinger wrote:
> >  #ifdef CONFIG_DEBUG_VERBOSE
> > -       printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
> > +       printk(KERN_EMERG "Double Fault\n");
> 
> dropped a newline.  we've largely made sure the newlines and such were
> as we want in the output ... in this case, it is not a matter of
> adding a newline where one did not exist before

Note that the 'printk' itself will add a required newline these days.

So unless you want an _empty_ line due to an earlier '\n', the change is 
correct.

If you do want the empty line, it should looke like

	printk(KERN_EMERG "\nDouble Fault\n");

but I suspect that you had the '\n' there because you had a previous 
printk which hadn't ended the line (in which case just removing it and 
relying on the KERN_EMERG causing a line break is the right thing to do).

		Linus
