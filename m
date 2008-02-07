Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbYBGKnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbYBGKnx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbYBGKnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:43:45 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38666 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754390AbYBGKno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:43:44 -0500
Date: Thu, 7 Feb 2008 11:43:43 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Ingo Molnar <mingo@elte.hu>
cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASLR: add possibility for more fine-grained tweaking
In-Reply-To: <20080207103231.GD16735@elte.hu>
Message-ID: <Pine.LNX.4.64.0802071143090.11914@vixen.sonytel.be>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
 <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu>
 <Pine.LNX.4.64.0802071120110.11914@vixen.sonytel.be> <20080207103231.GD16735@elte.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1261992843-1202381023=:11914"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1261992843-1202381023=:11914
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 7 Feb 2008, Ingo Molnar wrote:
> * Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > On Wed, 6 Feb 2008, Ingo Molnar wrote:
> > > @@ -541,6 +541,18 @@ config ELF_CORE
> > >  	help
> > >  	  Enable support for generating core dumps. Disabling saves about 4k.
> > >  
> > > +config COMPAT_BRK
> > > +	bool "Disable heap randomization"
> > > +	default y
> > > +	help
> > > +	  Randomizing heap placement makes heap exploits harder, but it
> > > +	  also breaks ancient binaries (including anything libc5 based).
> > > +	  This option changes the bootup default to heap randomization
> > > +	  disabled, and can be overriden runtime by setting
> > > +	  /proc/sys/kernel/randomize_va_space to 2.
> > > +
> > > +	  On non-ancient distros (post-2000 ones) Y is usually a safe choice.
> > 
> > Somehow my belly feeling tells me something is wrong with this description...
> > 
> > Ah, a negative option (Y -> disable).  So Y is always safe.
> > 
> > `non-ancient distros' really means `recent distros', and if you have 
> > one, then _N_ should be a safe choice, too?
> 
> yeah, you are right :-) I'll fix this.
> 
> btw., "non-ancient distros" does not just mean "recent distros", it 
> really means "just about any distro you picked up in the past 10 years". 
> You'd have to go out on a limb to find something historic (or keep 
> copying /lib/libc5 binaries to new distros like Pavel did) to still have 
> this particular libc5 assumption/breakage. [ Or at least so i hope =B-)]

Bummer, I guess my good old m68k recovery ramdisk is affected ;-)

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
---584349381-1261992843-1202381023=:11914--
