Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbXFYPT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbXFYPT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 11:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXFYPTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 11:19:18 -0400
Received: from mailhub.fokus.fraunhofer.de ([193.174.154.14]:33593 "EHLO
	mailhub.fokus.fraunhofer.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbXFYPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 11:19:17 -0400
Date: Mon, 25 Jun 2007 17:17:09 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: dwmw2@infradead.org
Cc: schilling@fokus.fraunhofer.de, linux-kernel@vger.kernel.org, david@lang.hm
Subject: Re: Linux Kernel include files
Message-ID: <467fdc75.0ficjl92unPDO1uk%Joerg.Schilling@fokus.fraunhofer.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm>
 <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de>
 <1182483527.10524.31.camel@shinybook.infradead.org>
In-Reply-To: <1182483527.10524.31.camel@shinybook.infradead.org>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

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

????

This uses double negation and is close to unreadable.

A kernel include file that defines an interface to a user space program
should be self containing (that means that all includes for all non-standard
types should be done inside these include files). Whether or not C-99 
types are used or not is less important than to use type definitions written 
in clean C so compilers other than gcc may use them.

> Personally, I think that's a load of bollocks. And it certainly doesn't
> apply to Linux-specific files like <linux/cdrom.h>, which are perfectly
> entitled to use a C standard from last millennium, regardless of
> namespace 'pollution' issues. That's why we continue to use the crappy
> __u32 types. Can you be more specific about why this is a problem? Don't
> we mostly define those crappy types using arch-specific knowledge, as
> 'int', 'long', etc?

I recommend you to install Sun Studio and to try to compile star or cdrtools
using Sun Studio by calling "make CCOM_suncc".

ftp://ftp.berlios.de/pub/star/alpha/
ftp://ftp.berlios.de/pub/cdrecord/alpha/

You may need to hand edit the file incs/<arch-dir>/{xconfig.h!rules.conf}

in order to enable the auto-disabled features.

In any case, self reading the error messages from Sun Studio helps more than
trying to discuss it.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
