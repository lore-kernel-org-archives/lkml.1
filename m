Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXGVXsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXGVXsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbXGVXsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:48:03 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:38833 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758295AbXGVXsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:48:01 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jul 2007 19:48:00 EDT
Subject: Re: voyager_{thread,cat}.c compile warnings
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?ISO-8859-1?Q?C=E9dric?= Augonnet <cedric.augonnet@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       J.E.J.Bottomley@HansenPartnership.com
In-Reply-To: <f56c1ba00707221549k768d7df9ke983160e634f4fe3@mail.gmail.com>
References: <46A282B2.8070501@googlemail.com>
	 <f56c1ba00707220833m267491afg277a028e6c103e31@mail.gmail.com>
	 <f56c1ba00707221549k768d7df9ke983160e634f4fe3@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sun, 22 Jul 2007 18:39:10 -0500
Message-Id: <1185147550.3431.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 18:49 -0400, Cédric Augonnet wrote:
> iff -urN a/arch/i386/mach-voyager/voyager_cat.c
> b/arch/i386/mach-voyager/voyager_cat.c
> --- /home/gonnet/tmp/linux-2.6.22/arch/i386/mach-voyager/voyager_cat.c  2007-07-20 11:50:17.000000000 -0400
> +++ linux-2.6.22/arch/i386/mach-voyager/voyager_cat.c   2007-07-22
> 11:24:34.000000000 -0400
> @@ -682,7 +682,7 @@
>                         outb(VOYAGER_CAT_END, CAT_CMD);
>                         continue;
>                 }
> -               if(eprom_size > sizeof(eprom_buf)) {
> +               if((unsigned)eprom_size > sizeof(eprom_buf)) {

Actually, no.  If gcc can deduce that the comparison is always false
then I want it not to build the body of the if.  The only thing I don't
know how to do is to shut up the warning in this case.  What you've done
is make gcc pretend it doesn't know the if is always false.

>                         printk("**WARNING**: Voyager insufficient size
> to read EPROM data, module 0x%x.  Need %d\n", i, eprom_size);
>                         outb(VOYAGER_CAT_END, CAT_CMD);
>                         continue;
> @@ -752,7 +752,7 @@
>                         outb(VOYAGER_CAT_END, CAT_CMD);
>                         continue;
>                 }
> -               if(eprom_size > sizeof(eprom_buf)) {
> +               if((unsigned)eprom_size > sizeof(eprom_buf)) {
>                         printk("**WARNING**: Voyager insufficient size
> to read EPROM data, module 0x%x.  Need %d\n", i, eprom_size);
>                         outb(VOYAGER_CAT_END, CAT_CMD);
>                         continue;
> diff -urN a/arch/i386/mach-voyager/voyager_thread.c
> b/arch/i386/mach-voyager/voyager_thread.c
> --- /home/gonnet/tmp/linux-2.6.22/arch/i386/mach-voyager/voyager_thread.c       2007-07-20 11:50:17.000000000 -0400
> +++
> linux-2.6.22/arch/i386/mach-voyager/voyager_thread.c        2007-07-22
> 11:27:13.000000000 -0400
> @@ -92,7 +92,7 @@
>         }
>  }
>  
> -static int
> +static void
>  thread(void *unused)
>  {
>         printk(KERN_NOTICE "Voyager starting monitor thread\n");

You didn't actually compile this, did you?  Apparently the signature of
the kthread_run function changed from returning void to returning int.
Unfortunately the person who fixed this up forgot to add a return 0 at
the end of the voyager thread() function .. which is the correct fix.

James


