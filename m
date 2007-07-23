Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbXGWAjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbXGWAjb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764222AbXGWAjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:39:23 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:57429 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763408AbXGWAjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AEWqETCR2AftXJ7P30zXKoYZIAutakbrPt1CY39Oo+rnD+loEv7cMiYAcoTwwIMPohPbdRaoS1CtwcCztdJhS7AlqEaer6YMTMrnII6zgM8+shVWL3+QZLg5Wn5bVv1GADLGr0baJGai5PKYlinjdM96j2yuDxj2ECtCOC+OCxM=
Message-ID: <f56c1ba00707221739r58a219c2tcbb465b314e14f99@mail.gmail.com>
Date: Sun, 22 Jul 2007 20:39:20 -0400
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: voyager_{thread,cat}.c compile warnings
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       J.E.J.Bottomley@hansenpartnership.com
In-Reply-To: <1185147550.3431.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46A282B2.8070501@googlemail.com>
	 <f56c1ba00707220833m267491afg277a028e6c103e31@mail.gmail.com>
	 <f56c1ba00707221549k768d7df9ke983160e634f4fe3@mail.gmail.com>
	 <1185147550.3431.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/22, James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Sun, 2007-07-22 at 18:49 -0400, Cédric Augonnet wrote:
> > iff -urN a/arch/i386/mach-voyager/voyager_cat.c
> > b/arch/i386/mach-voyager/voyager_cat.c
> > --- /home/gonnet/tmp/linux-2.6.22/arch/i386/mach-voyager/voyager_cat.c  2007-07-20 11:50:17.000000000 -0400
> > +++ linux-2.6.22/arch/i386/mach-voyager/voyager_cat.c   2007-07-22
> > 11:24:34.000000000 -0400
> > @@ -682,7 +682,7 @@
> >                         outb(VOYAGER_CAT_END, CAT_CMD);
> >                         continue;
> >                 }
> > -               if(eprom_size > sizeof(eprom_buf)) {
> > +               if((unsigned)eprom_size > sizeof(eprom_buf)) {
>
> Actually, no.  If gcc can deduce that the comparison is always false
> then I want it not to build the body of the if.  The only thing I don't
> know how to do is to shut up the warning in this case.  What you've done
> is make gcc pretend it doesn't know the if is always false.
>
> >                         printk("**WARNING**: Voyager insufficient size
> > to read EPROM data, module 0x%x.  Need %d\n", i, eprom_size);
> >                         outb(VOYAGER_CAT_END, CAT_CMD);
> >                         continue;
> > @@ -752,7 +752,7 @@
> >                         outb(VOYAGER_CAT_END, CAT_CMD);
> >                         continue;
> >                 }
> > -               if(eprom_size > sizeof(eprom_buf)) {
> > +               if((unsigned)eprom_size > sizeof(eprom_buf)) {
> >                         printk("**WARNING**: Voyager insufficient size
> > to read EPROM data, module 0x%x.  Need %d\n", i, eprom_size);
> >                         outb(VOYAGER_CAT_END, CAT_CMD);
> >                         continue;
> > diff -urN a/arch/i386/mach-voyager/voyager_thread.c
> > b/arch/i386/mach-voyager/voyager_thread.c
> > --- /home/gonnet/tmp/linux-2.6.22/arch/i386/mach-voyager/voyager_thread.c       2007-07-20 11:50:17.000000000 -0400
> > +++
> > linux-2.6.22/arch/i386/mach-voyager/voyager_thread.c        2007-07-22
> > 11:27:13.000000000 -0400
> > @@ -92,7 +92,7 @@
> >         }
> >  }
> >
> > -static int
> > +static void
> >  thread(void *unused)
> >  {
> >         printk(KERN_NOTICE "Voyager starting monitor thread\n");
>
> You didn't actually compile this, did you?  Apparently the signature of
> the kthread_run function changed from returning void to returning int.
> Unfortunately the person who fixed this up forgot to add a return 0 at
> the end of the voyager thread() function .. which is the correct fix.

Arg i was caught by that one.

> James
>

Ouch indeed this quick'n'dirty patch was, let's call it a full mistake
:) sorry for that, it could indeed not be tested as i don't have the
hardware.

Still, is it safe to compare two variable with different types anyway ?

In http://lists.infradead.org/pipermail/linux-pcmcia/2004-March/000586.html
they also have the same issue, they just do
s/ foo > 0xffff / foo & ~0xffff /
should not it solve the problem as well ?

Sorry again for the first patch, next time i'll just shut up.

Regards,
Cédric
