Return-Path: <linux-kernel-owner+w=401wt.eu-S937742AbYD1Uqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937742AbYD1Uqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbYD1UqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:46:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44715 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934270AbYD1UqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:46:19 -0400
Date: Mon, 28 Apr 2008 22:46:51 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Subject: Re: [PATCH 1/4] build: fix missing x86-specific help output
Message-ID: <20080428204651.GC18248@uranus.ravnborg.org>
References: <20080425223458.4eb88ba6@ephemeral> <20080428111839.5f8d5669@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428111839.5f8d5669@ephemeral>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 11:18:39AM -0400, Andres Salomon wrote:
> Note that this one is a general x86 fix, I probably should've separated it
> out from the other three.
> 
> On Fri, 25 Apr 2008 22:34:58 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > Normally 'make help' spits out architecture-specific targets (including
> > things like foo_defconfig).  However, it looks like ARCH was never changed
> > to SRCARCH during the x86 transition; the makefile still looks in
> > arch/i386/configs for arch-specific config files (if ARCH is i386, that is).
> > 
> > This changes it to use SRCARCH, which makes it properly display things
> > like i386_defconfig and x86_64_defconfig.
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > ---
> >  Makefile |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Makefile b/Makefile
> > index 3dbc826..e77149e 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1170,7 +1170,7 @@ rpm: include/config/kernel.release FORCE
> >  # Brief documentation of the typical targets used
> >  # ---------------------------------------------------------------------------
> >  
> > -boards := $(wildcard $(srctree)/arch/$(ARCH)/configs/*_defconfig)
> > +boards := $(wildcard $(srctree)/arch/$(SRCARCH)/configs/*_defconfig)
> >  boards := $(notdir $(boards))

I already had this fix in a previous patch.

> >  
> >  help:
> > @@ -1217,9 +1217,9 @@ help:
> >  	@echo  'Documentation targets:'
> >  	@$(MAKE) -f $(srctree)/Documentation/DocBook/Makefile dochelp
> >  	@echo  ''
> > -	@echo  'Architecture specific targets ($(ARCH)):'
> > +	@echo  'Architecture specific targets ($(SRCARCH)):'
> >  	@$(if $(archhelp),$(archhelp),\
> > -		echo '  No architecture specific help defined for $(ARCH)')
> > +		echo '  No architecture specific help defined for $(SRCARCH)')

So I used only this part.

	Sam
