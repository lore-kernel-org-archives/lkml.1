Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZASCRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZASCRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZASCRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:17:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:59132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485AbZASCRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:17:14 -0500
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090118190836.GA2294@uranus.ravnborg.org>
References: <1232287474.3130.19.camel@localhost.localdomain>
	 <20090118172800.GB22624@elte.hu> <20090118185034.GA26908@elte.hu>
	 <20090118190836.GA2294@uranus.ravnborg.org>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 07:46:05 +0530
Message-Id: <1232331365.3129.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 20:08 +0100, Sam Ravnborg wrote:
> > 
> > diff --git a/arch/x86/include/asm/swab.h b/arch/x86/include/asm/swab.h
> > index 306d417..613be68 100644
> > --- a/arch/x86/include/asm/swab.h
> > +++ b/arch/x86/include/asm/swab.h
> > @@ -1,12 +1,15 @@
> >  #ifndef _ASM_X86_SWAB_H
> >  #define _ASM_X86_SWAB_H
> >  
> > -#include <asm/types.h>
> > +#include <linux/types.h>
> > +#ifdef __KERNEL__
> >  #include <linux/compiler.h>
> > +#endif /* __KERNEL__ */
> 
> compiler.h includes should be nuked by make headers_instll automatically.
> 

But the problem is compiler.h provide extra line space in userspace
header files because of nuking them.

So I moved compiler.h in __KERNEL__ as extra cleanup, it is not harmful
but looks much nicer in userspace header files

--
JSR

