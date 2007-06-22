Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbXFVPA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbXFVPA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756286AbXFVPAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:00:21 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36390 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756201AbXFVPAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:00:20 -0400
Date: Fri, 22 Jun 2007 17:00:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, david@lang.hm,
       schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
Message-ID: <20070622150038.GN23017@stusta.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1182483527.10524.31.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 11:38:47AM +0800, David Woodhouse wrote:
> On Fri, 2007-06-22 at 01:38 +0200, Joerg Schilling wrote:
> > The main problems are not really hard to fix......
> > 
> > -	Most problems eem to be related to the fact that Linux does not
> > 	use C-99 based types in the kernel and the related type definitions 
> > 	are not written in plain C. This is something that should be fixed
> > 	with a source consolidation program or by defining aliases to 
> > 	C-99 types in case the compiler is not GCC.
> 
> 
> The argument has been made that the standard C99 types are _optional_,
> and anything included from a C library's headers without _explicitly_
> being included by the user shouldn't define those types.
> 
> Personally, I think that's a load of bollocks. And it certainly doesn't
> apply to Linux-specific files like <linux/cdrom.h>, which are perfectly
> entitled to use a C standard from last millennium, regardless of
> namespace 'pollution' issues. That's why we continue to use the crappy
> __u32 types. Can you be more specific about why this is a problem? Don't
> we mostly define those crappy types using arch-specific knowledge, as
> 'int', 'long', etc?
>...

It would certainly help if Joerg would tell what exactly breaks, but I 
spot one likely problem in include/asm-i386/types.h:

#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
typedef __signed__ long long __s64;
typedef unsigned long long __u64;
#endif

It might make sense to remove the #if and simply require that
a C compiler under Linux must know about the C99 "long long"?

> dwmw2

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

