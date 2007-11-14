Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbXKNWHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbXKNWHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 17:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXKNWHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 17:07:00 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:56602 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXKNWG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 17:06:59 -0500
Date: Wed, 14 Nov 2007 23:08:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
Message-ID: <20071114220840.GB10920@uranus.ravnborg.org>
References: <20071110204038.GA13140@uranus.ravnborg.org> <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org> <Pine.LNX.4.64.0711142116500.1818@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711142116500.1818@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman

On Wed, Nov 14, 2007 at 09:57:32PM +0100, Roman Zippel wrote:
> Hi,
> 
> On Sat, 10 Nov 2007, Sam Ravnborg wrote:
> 
> > +	if (p) {
> > +		char warning[100];
> > +		sprintf(warning, "Environment variable (%s = \"%s\")", env, p);
> > +		conf_filename = warning;
> > +		def_flags = SYMBOL_DEF << def;
> > +		if (def == S_DEF_USER) {
> > +			sym = sym_find(symname);
> > +			if (!sym)
> > +				return 1;
> > +		} else {
> > +			sym = sym_lookup(symname, 0);
> > +			if (sym->type == S_UNKNOWN)
> > +				sym->type = S_OTHER;
> > +		}
> > +		conf_set_sym_val(sym, def, def_flags, p);
> > +	}
> > +	return 0;
> 
> This is more complex than necessary, this should be enough:
> 
> 	sym = sym_find(symname);
> 	if (sym)
> 		sym_set_string_value(sym, p);
> 
> This is not a direct user interface, so the potential stricter error 
> checking is not really needed.
The value can be supplied on the command-line so we need to validate input.
The code is a copy of what happen when reading a all.config file and
the functionality should be equal.
Can we make that part simpler too?

By the way - I have never understood the purpose of the flags (S_DEF_USER etc.)
Can we have a few comments added to their definition?

> In general I think it's problematic that this is only checked, when the 
> config system is called, i.e. with a configured kernel adding ARCH would 
> have no effect, what makes this more confusing is that one can later omit 
> the ARCH variable, since it's saved in the .config.

The future plan is to set the architecture as part of the configuration step
and not by ARCH=. The ARCH= notation will continue to be supported
but will merely be a hint about the desired architecture.

The only place where it will play a real effect is when generating
allnoconfig, allyesconfig, allmodconfig, randconfig.

Some consistency check will likely be added - but a pure 'make' will
build the kernel with the configured ARCH and the configured CROSS_COMPILE
setting.

One of the blockers are that kconfig does not support more than one prompt
for a choice symbol. Is this something you can fix - or sketch how to fix it?

	Sam
