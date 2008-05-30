Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYE3H1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYE3H1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 03:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYE3H1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 03:27:37 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43851 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbYE3H1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 03:27:36 -0400
Date: Fri, 30 May 2008 09:28:16 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Section mismatch on latest git
Message-ID: <20080530072816.GA26169@uranus.ravnborg.org>
References: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com> <20080529000128.a106a7b1.akpm@linux-foundation.org> <20080529213845.d013a65e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529213845.d013a65e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 09:38:45PM -0700, Randy Dunlap wrote:
> On Thu, 29 May 2008 00:01:28 -0700 Andrew Morton wrote:
> 
> > On Mon, 26 May 2008 10:03:21 +0200 "Fabio Comolli" <fabio.comolli@gmail.com> wrote:
> > 
> > > Hi.
> > > I don't know it it has been reported already:
> > > 
> > > WARNING: vmlinux.o(.text+0x114bb): Section mismatch in reference from
> > > the function nopat() to the function .cpuinit.text:pat_disable()
> > > The function nopat() references
> > > the function __cpuinit pat_disable().
> > > This is often because nopat lacks a __cpuinit
> > > annotation or the annotation of pat_disable is wrong.
> > > 
> > > Config is in attachment.
> > > 
> > 
> > This should fix it:
> > 
> > --- a/arch/x86/mm/pat.c~arch-x86-mm-patc-nopat-should-be-__init
> > +++ a/arch/x86/mm/pat.c
> > @@ -34,7 +34,7 @@ void __cpuinit pat_disable(char *reason)
> >  	printk(KERN_INFO "%s\n", reason);
> >  }
> >  
> > -static int nopat(char *str)
> > +static int __init nopat(char *str)
> >  {
> >  	pat_disable("PAT support disabled.");
> >  	return 0;
> > _
> > 
> > 
> > It turns out that this was harmless.  However it might not have been -
> > I think that adding the ability to suppress all these warnings was a
> > mistake.  
> 
> It certainly has caused me to stop looking for/at them.
> More a sin of omission than one of commission.

My plan in this area is:
- Get my dev box operational again (awaiting spare parts from Intel)
- Get usual configs warning free (or almost warning free)
- Enable the warning in kbuild-next.git right after -rc1

As my dev box is down atm I have prioritized what I conviniently
can do on my mail-box (no defconfig/all*config builds).

	Sam
