Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYK0ICp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYK0ICp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 03:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbYK0ICg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 03:02:36 -0500
Received: from ozlabs.org ([203.10.76.45]:33228 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYK0ICg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 03:02:36 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: core_param: call these really, really early.
Date: Thu, 27 Nov 2008 18:32:21 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
References: <200811200123.41353.rusty@rustcorp.com.au> <20081126080846.GA7168@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081126080846.GA7168@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200811271832.21630.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2008 18:38:46 Heiko Carstens wrote:
> On Thu, Nov 20, 2008 at 01:23:41AM +1030, Rusty Russell wrote:
> > As soon as we have command line, so even before early_param.  They
> > just set vars, so it makes sense to do them as early as possible.
> >
> > This allows them to replace early_param, and fixes a bug in the new
> > cpu_alloc implementation patches which was a complete PITA to find.
> >
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> [...]
>
> > diff -r 65aebfe44ef1 init/main.c
> > --- a/init/main.c	Wed Nov 19 22:47:52 2008 +1030
> > +++ b/init/main.c	Wed Nov 19 23:58:08 2008 +1030
> > @@ -569,6 +588,10 @@
> >  	setup_arch(&command_line);
> >  	mm_init_owner(&init_mm, &init_task);
> >  	setup_command_line(command_line);
> > +	parse_args("Core params", command_line, __start___core_param,
> > +		   __stop___core_param - __start___core_param,
> > +		   unknown_core_ok);
> > +
> >  	unwind_setup();
> >  	setup_per_cpu_areas();
> >  	setup_nr_cpu_ids();
>
> ...but setup_arch() calls parse_early_param(). So how is this earlier
> than early_param?

True, I'd forgotten that most setup_arch()s call parse_early_param (there's a 
general call lower down in start_kernel).

I actually think start_kernel should take a char *params as a parameter, but 
that's a big multi-arch change I wasn't prepared to hack up just yet.

OK, now have three patches which clean up cmdline handling.  They're big :(  
Will test a little and post...

Cheers,
Rusty.







