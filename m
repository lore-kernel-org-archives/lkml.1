Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbXCaQMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbXCaQMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 12:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXCaQMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 12:12:05 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:37328 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbXCaQMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 12:12:03 -0400
Date: Sat, 31 Mar 2007 18:11:36 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Sam Ravnborg <sam@ravnborg.org>
cc: Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix dependency generation
In-Reply-To: <20070331064228.GA11023@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0703311804230.14457@scrub.home>
References: <460BA292.76E4.0078.0@novell.com> <20070331064228.GA11023@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 31 Mar 2007, Sam Ravnborg wrote:

> The problem is that tristate symbol represent three values.
> =n => CONFIG_SYMBOL is undefined
> =y => CONFIG_SYMBOL is defined
> =m => COMFIG_SYMBOL_MODULE is defined
> 
> The function split_config does not take into account the
> different values and 'fixing' this in fixdep is wrong.
> Because fixdep does not know if the variable is a tristate symbol or not
> so it can either blindly remove _MODULE (your patch)
> or each time it encounters _MODULE check for a symbol with and
> without _MODULE.

What really matters is that CONFIG_SYMBOL changed, one could optimize for 
the COMFIG_SYMBOL_MODULE case, but I don't think it's worth it, especially 
...

> The better fix is to teach the split_config function that
> for tristate symbols two files shall be created in the include/config
> hirachy. So for apm this gets:
> include/config/apm.h
> include/config/apm/module.h

if it requires thousands of new inodes for a feature which should be 
rarely used.

> This will make kconfig behave correct the day that someone add a config
> symbol with a _MODULE suffix.

I'd rather reserve that namespace, if it allows for the simpler version to 
just map all symbols to the basic config symbol name.

bye, Roman
