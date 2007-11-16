Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbXKPPkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbXKPPkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 10:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755202AbXKPPkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 10:40:05 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:29278 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbXKPPkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:40:03 -0500
Date: Fri, 16 Nov 2007 16:39:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 3/6] sclp: call sclp_init() from start_kernel().
Message-ID: <20071116153928.GA6162@osiris.boeblingen.de.ibm.com>
References: <20071116142942.978412023@de.ibm.com> <20071116143321.502691250@de.ibm.com> <20071116150942.GA5748@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116150942.GA5748@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 04:09:42PM +0100, Bastian Blank wrote:
> On Fri, Nov 16, 2007 at 03:29:45PM +0100, Martin Schwidefsky wrote:
> >  #else
> >  static inline void acpi_early_init(void) { }
> >  #endif
> > +#ifdef CONFIG_S390
> > +extern int sclp_init(void);
> > +#else
> > +static inline int sclp_init(void) {return 0;}
> > +#endif
> >  #ifndef CONFIG_DEBUG_RODATA
> >  static inline void mark_rodata_ro(void) { }
> >  #endif
> > @@ -643,6 +648,7 @@ asmlinkage void __init start_kernel(void
> >  	check_bugs();
> >  
> >  	acpi_early_init(); /* before LAPIC and SMP init */
> > +	sclp_init();
> 
> What happens if sclp_init fails? The other early init calls explicitely
> returns void and handels the error internal.

Nothing. I used to have an sclp call within __cpu_up() but that is gone
since I rewrote the patch that follows this one.
So this patch is just a leftover and I forgot that it isn't needed anymore.
Will be dropped.

Thanks for the hint!
