Return-Path: <linux-kernel-owner+w=401wt.eu-S1764958AbXKNU5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764958AbXKNU5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755243AbXKNU5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:57:39 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2363 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbXKNU5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:57:38 -0500
Date: Wed, 14 Nov 2007 21:57:32 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: use $K64BIT to set 64BIT with all*config targets
In-Reply-To: <11947274091127-git-send-email-sam@ravnborg.org>
Message-ID: <Pine.LNX.4.64.0711142116500.1818@scrub.home>
References: <20071110204038.GA13140@uranus.ravnborg.org>
 <11947274093185-git-send-email-sam@ravnborg.org> <11947274091127-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 10 Nov 2007, Sam Ravnborg wrote:

> +	if (p) {
> +		char warning[100];
> +		sprintf(warning, "Environment variable (%s = \"%s\")", env, p);
> +		conf_filename = warning;
> +		def_flags = SYMBOL_DEF << def;
> +		if (def == S_DEF_USER) {
> +			sym = sym_find(symname);
> +			if (!sym)
> +				return 1;
> +		} else {
> +			sym = sym_lookup(symname, 0);
> +			if (sym->type == S_UNKNOWN)
> +				sym->type = S_OTHER;
> +		}
> +		conf_set_sym_val(sym, def, def_flags, p);
> +	}
> +	return 0;

This is more complex than necessary, this should be enough:

	sym = sym_find(symname);
	if (sym)
		sym_set_string_value(sym, p);

This is not a direct user interface, so the potential stricter error 
checking is not really needed.

In general I think it's problematic that this is only checked, when the 
config system is called, i.e. with a configured kernel adding ARCH would 
have no effect, what makes this more confusing is that one can later omit 
the ARCH variable, since it's saved in the .config. I think it would be 
better to check for this directly in the Makefile and then use a separate 
tool to set the variable directly (which could be simply sed or a simple 
helper program).

bye, Roman
