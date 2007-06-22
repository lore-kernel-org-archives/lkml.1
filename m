Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbXFVQYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbXFVQYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbXFVQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:24:09 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4032 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961AbXFVQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:24:08 -0400
Date: Fri, 22 Jun 2007 18:24:16 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com,
       =?UTF-8?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <Pine.LNX.4.64.0706221711320.26568@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0706221735270.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
 <Pine.LNX.4.64.0706221602000.1817@scrub.home>
 <Pine.LNX.4.64.0706221711320.26568@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 22 Jun 2007, Jan Engelhardt wrote:

> V4L_USB_DRIVERS=y turns USB into =y? That can't be. It should give the "this
> depends on another symbol [USB] that is modular".

That's not how it works, the enclosed symbols depend now on 
V4L_USB_DRIVERS, which is a boolean and it can only have two states.
It doesn't matter on what V4L_USB_DRIVERS depends only the final value 
matters.
(BTW if check the dependency debug output in menuconfig/xconfig, you'll 
see which values are relevant in the calculation of a symbol value.)

> >I'm also a little irritated by the "default y", if I enable V4L I'm very 
> >tempted to check what other useless stuff has been automatically enabled, 
> >which I have to turn off again.
> 
> The default y only applies to the "menu" folders, not actual code.

I don't know that without checking the Makefile.

> There have been discussions to remove the default-ys again, I've sent a patch
> [http://lkml.org/lkml/2007/5/12/216], but nothing happened.
> 
> So, should all affected menuconfigs be transformed into tristates, what 
> do you think, Roman? Let me know so I can cook up a patch (hopefully 
> before 2.6.22) should they become tristate.

Using bool is clearly a bug and I'd prefer if it removed the defaults as 
well.

bye, Roman
