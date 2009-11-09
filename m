Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbZKIDR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbZKIDR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZKIDRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:17:55 -0500
Received: from ozlabs.org ([203.10.76.45]:33720 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZKIDRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:17:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the kernel (__ksymtab)
Date: Mon, 9 Nov 2009 13:47:57 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier.adi@gmail.com>,
       greg@kroah.com, linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <20091104171916.GA6323@merkur.ravnborg.org> <4AF2E00A.3010107@tuffmail.co.uk>
In-Reply-To: <4AF2E00A.3010107@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091347.57286.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Nov 2009 12:54:10 am Alan Jenkins wrote:
> Sam Ravnborg wrote:
> > On Wed, Nov 04, 2009 at 10:00:50AM +0000, Alan Jenkins wrote:
> >   
> >> Rusty Russell wrote:
> >>     
> >>> On Tue, 3 Nov 2009 08:36:17 pm Alan Jenkins wrote:
> >>>   
> >>>       
> >>>> +/*
> >>>> + * We use CPP macros since they are more familiar than assembly macros.
> >>>> + * Note that CPP macros eat newlines, so each statement must be terminated
> >>>> + * by a semicolon.
> >>>> + */
> >>>> +
> >>>> +#ifdef CONFIG_HAVE_SYMBOL_PREFIX
> >>>> +#define __SYM(sym) _##sym
> >>>> +#else
> >>>> +#define __SYM(sym) sym
> >>>> +#endif
> >>>>     
> >>>>         
> >>> Ideally, you would used MODULE_SYMBOL_PREFIX here, but of course it's a
> >>> string.  I don't think Kconfig can do arbitrary identifiers, so we can't
> >>> make CONFIG_SYMBOL_PREFIX empty or _.
> >>>
> >>> Perhaps clarify it to a bool CONFIG_HAVE_MODULE_UNDERSCORE_PREFIX then,
> >>> since that's what you're assuming here?
> >>>
> >>> Thanks,
> >>> Rusty.
> >>>       
> >> I made the same assumption in patch 4.  The arch defines  
> >> CONFIG_HAVE_SYMBOL_PREFIX, which then causes init/Kconfig to define  
> >> CONFIG_SYMBOL_PREFIX="_".
> >>
> >> Mike suggested that I hack kbuild instead, to do something like
> >>
> >> unquote = ...
> >> AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(unquote CONFIG_SYMBOL_PREFIX)
> >>
> >> I'm experimenting with the idea, but I haven't managed to get it working  
> >>     
> >
> > Something like this:
> > unquote = $(patsubst "%",%,$($1))
> >
> > AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(call unquote,CONFIG_SYMBOL_PREFIX)
> >
> > But the readability is low so we could be better off doing it direct:
> >
> > AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(patsubst "%",",$(CONFIG_SYMBOL_PREFIX))
> >
> > 	Sam
> >   
> 
> Thanks to both of you, I have something that works now. 

I've taken this, but really, it's overkill.  Changing the config to a fixed
"underscore or nothing" was simpler and demonstrably sufficient for all cases
in the last 5 years.

Thanks,
Rusty.
