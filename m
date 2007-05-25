Return-Path: <linux-kernel-owner+w=401wt.eu-S1764128AbXEYTFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764128AbXEYTFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbXEYTFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:05:39 -0400
Received: from 2.0-25.235.16.216.in-addr.arpa ([216.16.235.2]:46832 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbXEYTFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:05:39 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 25 May 2007 15:04:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
In-Reply-To: <46572DAF.1000108@zytor.com>
Message-ID: <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
 <46572DAF.1000108@zytor.com>
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

On Fri, 25 May 2007, H. Peter Anvin wrote:

> Robert P. J. Day wrote:
> > Convert old/obsolete NORET_TYPE and ATTRIB_NORET macros to use the
> > newer standard of "__noreturn" as defined in compiler-gcc.h.
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>
> > 1) in a function declaration, the "__noreturn" will go at the end of
> > the declaration.
> >
> > 2) in a definition, "__noreturn" will go between the return type and
> > the function name
> >
> > 3) in a function typedef, "__noreturn" will go immediately after the
> > return type, just like with definitions.
> >
> > 4) if a function definition already includes "__noreturn", there's no
> > point in having any external references to it also say the same thing.
> > (right?)
>
> This is dumb, though.
>
> "void __noreturn" is redundant.  It would be much cleaner to have a
> macro which amounts to "void __attribute__((noreturn))" and use it
> instead of giving a return type.
>
> Even "void" as the return type is bogus -- the function never
> returns so it doesn't *have* a return type...

i agree, and i just did a quick test and noticed that, if you try to
declare a function thusly:

  f() __attribute__((noreturn)) ;

you get:

  warning: data definition has no type or storage class

but gcc doesn't complain if you declare it thusly:

  __attribute__((noreturn)) f() ;

that strikes me as a flaw in gcc, no?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
