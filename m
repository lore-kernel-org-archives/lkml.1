Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZARTno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZARTno (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZARTn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:43:27 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:39262 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZARTn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:43:27 -0500
Date: Sun, 18 Jan 2009 20:45:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090118194510.GA2507@uranus.ravnborg.org>
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118172800.GB22624@elte.hu> <20090118185034.GA26908@elte.hu> <20090118190836.GA2294@uranus.ravnborg.org> <20090118190941.GC858@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090118190941.GC858@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 08:09:41PM +0100, Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sun, Jan 18, 2009 at 07:50:34PM +0100, Ingo Molnar wrote:
> > > 
> > > hm, i just noticed this detail:
> > > 
> > > commit 3521c5eef990515719614e212b26ea49e610d072
> > > Author: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > Date:   Sat Jan 17 19:25:46 2009 +0530
> > > 
> > >     headers_check fix: x86, swab.h
> > >     
> > >     fix the following 'make headers_check' warnings:
> > >     
> > >       usr/include/asm/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
> > >       usr/include/asm/swab.h:7: found __[us]{8,16,32,64} type without #include <linux/types.h>
> > >       usr/include/asm/swab.h:10: leaks CONFIG_X86 to userspace where it is not valid
> > >       usr/include/asm/swab.h:40: leaks CONFIG_X86 to userspace where it is not valid
> > >     
> > >     Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > 
> > > diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
> > > index 306d417..613be68 100644
> > > --- a/arch/x86/include/asm/swab.h
> > > +++ b/arch/x86/include/asm/swab.h
> > > @@ -1,12 +1,15 @@
> > >  #ifndef _ASM_X86_SWAB_H
> > >  #define _ASM_X86_SWAB_H
> > >  
> > > -#include <asm/types.h>
> > > +#include <linux/types.h>
> > > +#ifdef __KERNEL__
> > >  #include <linux/compiler.h>
> > > +#endif /* __KERNEL__ */
> > 
> > compiler.h includes should be nuked by make headers_instll automatically.
> 
> So the compiler.h include can be left there, and headers_check will not 
> warn about it?

Correct.

	Sam
