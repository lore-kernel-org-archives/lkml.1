Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYBJTb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYBJTb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYBJTbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:31:48 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57514 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYBJTbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:31:47 -0500
Date: Sun, 10 Feb 2008 20:31:53 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
Message-ID: <20080210193153.GC13733@uranus.ravnborg.org>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <47AEFB40.5070208@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AEFB40.5070208@web.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 02:25:20PM +0100, Jan Kiszka wrote:
> Sam Ravnborg wrote:
> > ...
> > +extern int kgdb_may_fault;
> > I searched but I could not find any places this
> > variable were set to anuthing else than 0 neither where it was tested.
> 
> This is a leftover from the old jmp-on-fault logic that was missed by
> this tree. I have a patch under test that kills this (and further 150
> LOC) from the core.
> 
> > 
> > diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
> > new file mode 100644
> > index 0000000..00263c0
> > --- /dev/null
> > +++ b/lib/Kconfig.kgdb
> > @@ -0,0 +1,37 @@
> > +
> > +menuconfig KGDB
> > +	bool "KGDB: kernel debugging with remote gdb"
> > +	select FRAME_POINTER
> > +	depends on HAVE_ARCH_KGDB
> > +	depends on DEBUG_KERNEL && EXPERIMENTAL
> > +	help
> > +	  If you say Y here, it will be possible to remotely debug the
> > +	  kernel using gdb.  Documentation of kernel debugger is available
> > +	  at http://kgdb.sourceforge.net as well as in DocBook form
> > +	  in Documentation/DocBook/.  If unsure, say N.
> > +
> > +config HAVE_ARCH_KGDB_SHADOW_INFO
> > +	bool
> > +
> > 
> > Please add:
> > config HAVE_ARCH_KGDB
> > 	bool
> > 
> > So we later in x86/Kconfig can do:
> > config X86
> > 	select HAVE_ARCH_KGDB
> > 
> > And we can get rid of (from x86/Kconfig):
> > +config HAVE_ARCH_KGDB
> > +	def_bool y
> > 
> > 
> > Back to Kconfig.kgdb:
> > 
> > +config KGDBOC
> > +	tristate "KGDB: use kgdb over the serial console"
> > +	depends on KGDB
> > 
> > Can we have a more descriptive name here.
> > For example:
> > config KGDB_SERIAL_CONSOLE
> > It is only used in one place so there is no
> > specific need for such a magic short name.
> > 
> 
> Is the patch below OK? I also added an "if KGB" to unbreak kgdb's
> kconfig menu again and included two minor cleanups I posted yesterday.

Looks OK - but I think Ingo already addressed this.

	Sam
