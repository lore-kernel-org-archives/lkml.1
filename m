Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbYHGVXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbYHGVXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYHGVWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:22:32 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47388 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYHGVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:22:30 -0400
Date: Thu, 7 Aug 2008 10:12:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       LKML <linux-kernel@vger.kernel.org>, Glauber Costa <gcosta@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86, acpi: temp_stack is used only when CONFIG_SMP is
	set
Message-ID: <20080807081245.GA1647@elf.ucw.cz>
References: <20080803165210.GC5414@joi> <alpine.LNX.1.10.0808031901120.7765@titan.stealer.net> <20080803172535.GE5414@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080803172535.GE5414@joi>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > arch/x86/kernel/acpi/sleep.c:24: warning: 'temp_stack' defined but not used
> > > 
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > Cc: Glauber Costa <gcosta@redhat.com>
> > > Cc: Pavel Machek <pavel@suse.cz>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > ---
> > >  arch/x86/kernel/acpi/sleep.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> > > index fa2161d..9103cb6 100644
> > > --- a/arch/x86/kernel/acpi/sleep.c
> > > +++ b/arch/x86/kernel/acpi/sleep.c
> > > @@ -20,7 +20,7 @@ unsigned long acpi_realmode_flags;
> > >  /* address in low memory of the wakeup routine. */
> > >  static unsigned long acpi_realmode;
> > >  
> > > -#ifdef CONFIG_64BIT
> > > +#ifdef CONFIG_SMP
> > >  static char temp_stack[10240];
> > >  #endif
> > >  
> > 
> > Now it still generates the warning, but on i386 with CONFIG_SMP set, 
> > instead of x86_64 without CONFIG_SMP. We only need temp_stack, when both 
> > CONFIG_64BIT and CONFIG_SMP are activated.
> 
> Yes. Thanks for looking at the patch!
> 
> ---
> From c6e673acf02e8bf04866cadf17c1cb1fa4d852ea Mon Sep 17 00:00:00 2001
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] x86, acpi: temp_stack is used only when CONFIG_64BIT && CONFIG_SMP is set
> 
> arch/x86/kernel/acpi/sleep.c:24: warning: 'temp_stack' defined but not used
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Glauber Costa <gcosta@redhat.com>

Acked-by: Pavel Machek <pavel@suse.cz>

Ingo, can you merge this one?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
