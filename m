Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbXIYLna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbXIYLna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXIYLnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:43:22 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38132 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751917AbXIYLnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:43:21 -0400
Date: Tue, 25 Sep 2007 13:43:17 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Joe Perches <joe@perches.com>
cc: Rob Landley <rob@landley.net>,
       Michael Opdenacker <michael@free-electrons.com>, linux-tiny@selenic.com,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Celinux-dev] Re: [Announce] Linux-tiny project revival
In-Reply-To: <1190319360.26101.154.camel@localhost>
Message-ID: <Pine.LNX.4.62.0709251340310.14632@pademelon.sonytel.be>
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net>
 <1190319360.26101.154.camel@localhost>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-461112960-1190720597=:14632"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-461112960-1190720597=:14632
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 20 Sep 2007, Joe Perches wrote:
> On Thu, 2007-09-20 at 15:38 -0500, Rob Landley wrote:
> > And so far no behavior has changed.  But now the _fun_ part is, you can add a 
> > config symbol for "what is the minimum loglevel I care about?"  Set that as a 
> > number from 0-9.  And then you can define the printk to do:
> > 
> > #define printk(level, str, ...) \
> >   do { \
> >     if (level < CONFIG_PRINTK_DOICARE) \
> >       actual_printk("<" #level ">" str, __VA_ARGS__); \
> >   } while(0);
> > 
> > And viola (however you spell that, I think I'm using the stringed instrument 
> 
> > But this doesn't _completely_ eliminate 
> > printks, so you can still get the panic() calls and such.  You tweak precisly 
> > how much bloat you want, using the granularity information that's already 
> > there in the source code...
> > Opinions?
> 
> I'd rather take the opportunity to convert all the printks to
> use pr_<level>.  That way, you can pick'n'choose if you want
> arbitrary combinations of KERN_<level> compiled in or not.

Or:

    if ((1 << level) & CONFIG_PRINTK_MASK)
	actual_printk("<" #level ">" str, __VA_ARGS__);

But it would indeed be nice to have all of pr_<level> (and not only pr_info()
and pr_debug()) anyway.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-461112960-1190720597=:14632--
