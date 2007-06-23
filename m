Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbXFWWdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbXFWWdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 18:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750837AbXFWWdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 18:33:47 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:36443 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFWWdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 18:33:46 -0400
Date: Sat, 23 Jun 2007 15:33:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Satyam Sharma <satyam.sharma@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux and Kernel Video <video4linux-list@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, toralf.foerster@gmx.de,
       Oliver Neukum <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0706231525130.4914@shell4.speakeasy.net>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de>  <1182518566.14289.20.camel@gaivota>
  <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jun 2007, Satyam Sharma wrote:
> On 6/23/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> > [...]
> > What you have is tristate depends on bool depends on tristate.  The bool
> > between the two tristates "promotes" the first tristate from m to y.
> > [...]
> > Or another way, add the dependencies of the menuconfig to the if statement:
> > diff -r dfbe7cc4e21e drivers/media/video/Kconfig
> > --- a/drivers/media/video/Kconfig       Thu Jun 21 16:02:50 2007 -0700
> > +++ b/drivers/media/video/Kconfig       Fri Jun 22 13:10:43 2007 -0700
> > @@ -691,7 +691,7 @@ menuconfig V4L_USB_DRIVERS
> >         depends on USB
> >         default y
> >
> > -if V4L_USB_DRIVERS
> > +if V4L_USB_DRIVERS && USB
> >
> >  source "drivers/media/video/pvrusb2/Kconfig"
> >
> > Now all the usb drivers will gain USB as a dependency directly and can't be
> > set to something higher than USB.
>
> Ok, so we add this as solution 2.(c) to the reply I just sent to Jan :-)
>
> But I still prefer 2.(b) -- making the config scripts intelligent so that if a
> given "menuconfig FOO depends on BAR", then all the "config BAZ"s
> inside this menuconfig also automatically "depend on" BAR too.

Of course, there currently is no "inside" a menuconfig.  You would have to do
something like make everything inside an "if FOO / endif" gain not just a
dependency on FOO, but also gain a dependency on all of FOO's dependencies.

> This is simpler in the long run because it requires least amount
> (actually none) of redundant typing and would continue to work in
> the future if/when the:
>
> menuconfig FOO
> if FOO
> ...
> endif # FOO
>
> idiom is converted to an:
>
> configmenu FOO
> ...
> endconfigmenu # FOO
>
> kind of idiom ...

Like that I suggested here?
http://article.gmane.org/gmane.linux.kernel/524823

Basically, make menuconfig work like menu does, except the menu itself can be
turned on and off.  Instead of having menuconfig work like a config, but with
some kind of "menu" hint.  It seems like the former is more in line with what
menuconfig is actually used for.
