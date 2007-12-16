Return-Path: <linux-kernel-owner+w=401wt.eu-S1757788AbXLPTpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788AbXLPTpL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbXLPTpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:45:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:46260 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbXLPTo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:44:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SNH68tZR0SlZNesogwra5lk75CJPbDpcQRQCCfAJCi5QMDTT/bKESUlDQDtsc/RewBMyygKXn88iz7ISBvx3IwvTg7keKAK159shTMDBFJpsa7vsWs9d7nBJpc0IcxL6x68brlOftYstNrKKt8Tazscx7Uw27Nwsby0/uArPu6k=
Subject: Re: [PATCH 3/4] x86: Unify local_{32|64}.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <47656C00.6000501@zytor.com>
References: <1197806640.3749.42.camel@brick>  <47656C00.6000501@zytor.com>
Content-Type: text/plain
Date: Sun, 16 Dec 2007 11:45:01 -0800
Message-Id: <1197834301.3749.69.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-16 at 10:18 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > Introduce macros to deal with X86_32 using longs and X86_64
> > using quads.  Small comment fixes to make files match.
> >  
> >  #define local_read(l)	atomic_long_read(&(l)->a)
> >  #define local_set(l,i)	atomic_long_set(&(l)->a, (i))
> > +/*
> > + * X86_32 uses longs
> > + * X86_64 uses quads
> > + */
> > +#ifdef CONFIG_X86_32
> > +# define ASM_INC incl
> > +# define ASM_DEC decl
> > +# define ASM_ADD addl
> > +# define ASM_SUB subl
> > +# define ASM_XADD xaddl
> > +#else
> > +# define ASM_INC incq
> > +# define ASM_DEC decq
> > +# define ASM_ADD addq
> > +# define ASM_SUB subq
> > +# define ASM_XADD xaddq
> > +#endif
> >  
> 
> Please put these in <asm/asm.h> using the _ASM_* namespace and include 
> the quotation marks.

Will revise.

> 
> >  #ifdef CONFIG_X86_32
> >  # include "local_32.h"
> > diff --git a/include/asm-x86/local_32.h b/include/asm-x86/local_32.h
> > index f3bc4d9..ff6d1d2 100644
> > --- a/include/asm-x86/local_32.h
> > +++ b/include/asm-x86/local_32.h
> > @@ -4,21 +4,21 @@
> >  static inline void local_inc(local_t *l)
> >  {
> >  	__asm__ __volatile__(
> > -		"incl %0"
> > +		"ASM_INC %0"
> >  		:"+m" (l->a.counter));
> 
> You're substituting a macro *inside* a string here.
> 

*ahem*, oops.  Will fix.

Harvey

