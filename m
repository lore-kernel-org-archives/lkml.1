Return-Path: <linux-kernel-owner+w=401wt.eu-S1764389AbXEYRfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764389AbXEYRfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759996AbXEYRfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:35:38 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44445 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757605AbXEYRfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:35:37 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 25 May 2007 13:33:29 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
In-Reply-To: <a781481a0705241153m29781dd2u825c0e9bfdb6beb0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705251330590.13229@localhost.localdomain>
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain> 
 <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain> 
 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain> 
 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain> 
 <m37ir0iodl.fsf@maximus.localdomain>  <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
  <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain> 
 <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com> 
 <Pine.LNX.4.64.0705241239560.10926@localhost.localdomain>
 <a781481a0705241153m29781dd2u825c0e9bfdb6beb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Satyam Sharma wrote:

> On 5/24/07, Robert P. J. Day <rpjday@mindspring.com> wrote:

> > while in actual definitions, they typically go after the return type,
> > as in arch/arm/kernel/traps.c:
> >
> > void __attribute__((noreturn)) __bug(const char *file, int line)
> > {
> >         printk(KERN_CRIT"kernel BUG at %s:%d!\n", file, line);
> >         *(int *)0 = 0;
> >
> >         /* Avoid "noreturn function does return" */
> >         for (;;);
> > }
>
> Function attributes don't need to appear in function definitions at all.
> (I've not come across such cases often, so this is certainly not the
> standard). Anyway, the above is a case that the function lacks a
> separate declaration which is why we put it there at the definition.
> And yes, if we really do have to put an attribute in the function
> definition, then we do need to place it _before_ the function name.

right -- the above was referring only to those instances (and there
are some of them) where there is no declaration, only a definition.

i'll take another shot at a patch shortly.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
