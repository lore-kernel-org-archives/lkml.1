Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZASFZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZASFZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 00:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZASFZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 00:25:47 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:40576 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbZASFZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 00:25:47 -0500
Date: Mon, 19 Jan 2009 06:27:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
Message-ID: <20090119052727.GA6422@uranus.ravnborg.org>
References: <1232287474.3130.19.camel@localhost.localdomain> <20090118172800.GB22624@elte.hu> <20090118185034.GA26908@elte.hu> <20090118190836.GA2294@uranus.ravnborg.org> <1232331365.3129.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232331365.3129.7.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 07:46:05AM +0530, Jaswinder Singh Rajput wrote:
> On Sun, 2009-01-18 at 20:08 +0100, Sam Ravnborg wrote:
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
> > 
> 
> But the problem is compiler.h provide extra line space in userspace
> header files because of nuking them.
> 
> So I moved compiler.h in __KERNEL__ as extra cleanup, it is not harmful
> but looks much nicer in userspace header files

We should fix scripts/headers_install.pl to drop the newline too.
This is much better than adding of ifdef __KERNEL__ around
the include of compiler.h.

	Sam
