Return-Path: <linux-kernel-owner+w=401wt.eu-S1765414AbXEYVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765414AbXEYVMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbXEYVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:12:17 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49948 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXEYVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:12:16 -0400
X-Originating-Ip: 72.143.65.211
Date: Fri, 25 May 2007 17:10:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn"
 standard.
In-Reply-To: <46573B23.1090700@zytor.com>
Message-ID: <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
 <46572DAF.1000108@zytor.com> <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
 <46573B23.1090700@zytor.com>
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
> >
> >
> >   f() __attribute__((noreturn)) ;
> >
> > you get:
> >
> >   warning: data definition has no type or storage class
> >
> > but gcc doesn't complain if you declare it thusly:
> >
> >   __attribute__((noreturn)) f() ;
> >
> > that strikes me as a flaw in gcc, no?
> >
>
> Doesn't matter.  gcc accepts "void __attribute__((noreturn)) f();", and
> thus, one can define:
>
> #define __noreturn void __attribute__((noreturn))
>
> ... and declare functions as:
>
> __noreturn f();
>
> ... which is the syntactially sane way of doing it.

that may be, but keep in mind that gcc allows attributes to *follow*
the parameter list as well, and some people might prefer to do the
following:

  f() __noreturn;

that would fail badly if you defined __noreturn as you suggest.

  is there, in fact, a tradition for attribute usage, along the lines
of what satyam suggested earlier?  because once there's an established
standard, that's going to dictate what is and isn't possible in terms
of macros and shortcuts.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
