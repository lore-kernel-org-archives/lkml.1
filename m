Return-Path: <linux-kernel-owner+w=401wt.eu-S933860AbXDASpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933860AbXDASpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:45:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933869AbXDASpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:45:10 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46826 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933860AbXDASpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:45:09 -0400
Date: Sun, 1 Apr 2007 20:45:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix dependency generation
Message-ID: <20070401184553.GC10113@uranus.ravnborg.org>
References: <460BA292.76E4.0078.0@novell.com> <20070331064228.GA11023@uranus.ravnborg.org> <Pine.LNX.4.64.0703311804230.14457@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703311804230.14457@scrub.home>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 06:11:36PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Sat, 31 Mar 2007, Sam Ravnborg wrote:
> 
> > The problem is that tristate symbol represent three values.
> > =n => CONFIG_SYMBOL is undefined
> > =y => CONFIG_SYMBOL is defined
> > =m => COMFIG_SYMBOL_MODULE is defined
> > 
> > The function split_config does not take into account the
> > different values and 'fixing' this in fixdep is wrong.
> > Because fixdep does not know if the variable is a tristate symbol or not
> > so it can either blindly remove _MODULE (your patch)
> > or each time it encounters _MODULE check for a symbol with and
> > without _MODULE.
> 
> What really matters is that CONFIG_SYMBOL changed, one could optimize for 
> the COMFIG_SYMBOL_MODULE case, but I don't think it's worth it, especially 
> ...
> 
> > The better fix is to teach the split_config function that
> > for tristate symbols two files shall be created in the include/config
> > hirachy. So for apm this gets:
> > include/config/apm.h
> > include/config/apm/module.h
> 
> if it requires thousands of new inodes for a feature which should be 
> rarely used.
> 
> > This will make kconfig behave correct the day that someone add a config
> > symbol with a _MODULE suffix.
> 
> I'd rather reserve that namespace, if it allows for the simpler version to 
> just map all symbols to the basic config symbol name.

OK, I have forwarded Jan's patch for inclusion (the bug-fix part).

	Sam

> 
> bye, Roman
