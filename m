Return-Path: <linux-kernel-owner+w=401wt.eu-S1761130AbZDJUMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130AbZDJUMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756516AbZDJUMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:12:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60960 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZDJUMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:12:01 -0400
Date: Fri, 10 Apr 2009 22:15:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       josh@freedesktop.org
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090410201504.GA23364@elf.ucw.cz>
References: <1239385015.3169.15.camel@ht.satnam> <20090410175545.GB16843@elf.ucw.cz> <20090410191334.GA25336@uranus.ravnborg.org> <1239391016.3169.49.camel@ht.satnam> <20090410192939.GB25551@uranus.ravnborg.org> <1239392981.5943.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239392981.5943.1.camel@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-04-11 01:19:41, Jaswinder Singh Rajput wrote:
> On Fri, 2009-04-10 at 21:29 +0200, Sam Ravnborg wrote:
> > On Sat, Apr 11, 2009 at 12:46:56AM +0530, Jaswinder Singh Rajput wrote:
> > > Sorry, I was confused by this sparse warning on 64 bit box:
> > > 
> > > CHECK   arch/x86/kernel/acpi/sleep.c
> > >  arch/x86/kernel/acpi/sleep.c:107:16: warning: constant 0x123456789abcdef0 is so big it is long
> > > 
> > > atleast I found problem in sparse ;-)
> > 
> > Sparse tells you that the constant is so big it is long - correct.
> > So rather than being implicit appending an L would make sparse happy.
> > 
> > So please use the constant 0x123456789abcdef0L and I think sparse is silenced.
> > And code/functionality is the same.
> > 
> 
> Yes, this fixes the sparse warning, Thanks :-)

Acked-by: Pavel Machek <pavel@ucw.cz>

> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 7c243a2..3445d0f 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -104,7 +104,7 @@ int acpi_save_state_mem(void)
>         initial_gs = per_cpu_offset(smp_processor_id());
>  #endif
>         initial_code = (unsigned long)wakeup_long64;
> -       saved_magic = 0x123456789abcdef0;
> +       saved_magic = 0x123456789abcdef0L;
>  #endif /* CONFIG_64BIT */
>  
>         return 0;
> 
> --
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
