Return-Path: <linux-kernel-owner+w=401wt.eu-S1754032AbZDLR1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbZDLR1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZDLR0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:26:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37002 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbZDLR0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:26:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Date: Sun, 12 Apr 2009 19:25:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
References: <1239385015.3169.15.camel@ht.satnam> <1239392981.5943.1.camel@localhost.localdomain> <20090410201504.GA23364@elf.ucw.cz>
In-Reply-To: <20090410201504.GA23364@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904121925.59814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 April 2009, Pavel Machek wrote:
> On Sat 2009-04-11 01:19:41, Jaswinder Singh Rajput wrote:
> > On Fri, 2009-04-10 at 21:29 +0200, Sam Ravnborg wrote:
> > > On Sat, Apr 11, 2009 at 12:46:56AM +0530, Jaswinder Singh Rajput wrote:
> > > > Sorry, I was confused by this sparse warning on 64 bit box:
> > > > 
> > > > CHECK   arch/x86/kernel/acpi/sleep.c
> > > >  arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> > > > 
> > > > atleast I found problem in sparse ;-)
> > > 
> > > Sparse tells you that the constant is so big it is long - correct.
> > > So rather than being implicit appending an L would make sparse happy.
> > > 
> > > So please use the constant 0x123456789abcdef0L and I think sparse is silenced.
> > > And code/functionality is the same.
> > > 
> > 
> > Yes, this fixes the sparse warning, Thanks :-)
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>

OK

Ingo, are you going to take it or should I handle it?

Rafael


> > diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> > index 7c243a2..3445d0f 100644
> > --- a/arch/x86/kernel/acpi/sleep.c
> > +++ b/arch/x86/kernel/acpi/sleep.c
> > @@ -104,7 +104,7 @@ int acpi_save_state_mem(void)
> >         initial_gs = per_cpu_offset(smp_processor_id());
> >  #endif
> >         initial_code = (unsigned long)wakeup_long64;
> > -       saved_magic = 0x123456789abcdef0;
> > +       saved_magic = 0x123456789abcdef0L;
> >  #endif /* CONFIG_64BIT */
> >  
> >         return 0;
> > 
> > --
