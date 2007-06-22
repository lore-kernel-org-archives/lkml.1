Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbXFVPSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbXFVPSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 11:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756703AbXFVPS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 11:18:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:15456 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbXFVPSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 11:18:25 -0400
Date: Fri, 22 Jun 2007 17:18:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com,
       =?UTF-8?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <Pine.LNX.4.64.0706221602000.1817@scrub.home>
Message-ID: <Pine.LNX.4.64.0706221711320.26568@fbirervta.pbzchgretzou.qr>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
 <Pine.LNX.4.64.0706221602000.1817@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 22 2007 16:27, Roman Zippel wrote:
>
>> In this specific case, all V4L USB drivers depends on V4L_USB_DRIVERS,
>> that depends, in turn, on USB. So, if USB is not selected,
>> V4L_USB_DRIVERS should be unselected, unselecting zc0301.
>> 
>> Unfortunately, the Kernel building system is not properly handling it.
>> 
>> This is the (snipped) media/video/Kconfig:
>> 
>> menuconfig V4L_USB_DRIVERS
>>         bool "V4L USB devices"
>>         depends on USB
>>         default y
>> 
>
>The menuconfig patches were a little aggressive here, it created a config 
>symbol where there was none before and in this case it even changed 
>dependencies (it turns USB into a bool).

V4L_USB_DRIVERS=y turns USB into =y? That can't be. It should give the "this
depends on another symbol [USB] that is modular".

>I'm also a little irritated by the "default y", if I enable V4L I'm very 
>tempted to check what other useless stuff has been automatically enabled, 
>which I have to turn off again.

The default y only applies to the "menu" folders, not actual code.
There have been discussions to remove the default-ys again, I've sent a patch
[http://lkml.org/lkml/2007/5/12/216], but nothing happened.


So, should all affected menuconfigs be transformed into tristates, what 
do you think, Roman? Let me know so I can cook up a patch (hopefully 
before 2.6.22) should they become tristate.


Thanks,
	Jan
-- 
