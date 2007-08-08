Return-Path: <linux-kernel-owner+w=401wt.eu-S938479AbXHHVlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938479AbXHHVlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 17:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936953AbXHHVkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 17:40:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:34888 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936744AbXHHVkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 17:40:51 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19yJd5ndEBycdNY0pAoLYCU8IP5xCu+EJJKMR58GX
	to++2YYNBKZ6rH
Date: Wed, 8 Aug 2007 23:40:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Oncaphillis <oncaphillis@snafu.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: UART misbehaves under Linkstation/KuroBoxHG
In-Reply-To: <46BA320E.1030608@snafu.de>
Message-ID: <Pine.LNX.4.60.0708082323420.6767@poirot.grange>
References: <46B9CE82.1050000@snafu.de> <Pine.LNX.4.60.0708082219520.6767@poirot.grange>
 <46BA320E.1030608@snafu.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007, Oncaphillis wrote:

>  So that's ok ? No misconfiguration ? And that setserial tells
>  me the port is 0x000 ?

Yes, everything looks ok, don't know why, setserial reports 0 here too, 
but it doesn't cause me any (visible) problems.

>  I thought the dts file which
>  comes with the linkstation kernel describes the ports and IRQs
>  but poking there didn't change anything. It seems like the kernel
>  is ignoring the serial settings in the dts-file (which I do not
>  realy understand) all together.

Believe me, it doesn't ignore them:-) Don't know what exactly you were 
poking at there, but it should be quite easy to break it by changing 
clocks / address / irq...

>   I started with a debian distro
>   http://www.kurobox.com/mwiki/index.php/Debian_sylver
> 
>   Hmm I tried my very best to eliminate this everywhere. Actually I
>   resurrected the ARV00 device by creating a soft link to a ttySx
>   with during bootup within the udev filesystem.
> 
>   <snip>
>         if [ ! -e /dev/AVR00 ];then
>          cat /proc/tty/driver/serial | grep 80004500 | grep -q 0:
>            && AVR=/dev/ttyS0 || AVR=/dev/ttyS1
>          echo "Making AVR00 link to "$AVR;
>          ln -s $AVR /dev/AVR00
>         fi;
>   </snip>
> 
> Stole the trick from the avr_evtd startup script...

Well, just do "ls -l /dev/AVR00", then "lsof /dev/ttyS0".

In principle, as mentioned elsewhere before, you don't need any daemons on 
linkstation/kurobox now for "basic" operation, i.e., the kernel disables 
the watchdog on startup, and properly sends reboot and power-off commands 
to the AVR itself without any userspace support. So, at least for a test, 
you could stop all those daemons. You need them though if you want to use 
the buttons to power down / reboot / whatever, do other fancy things with 
the AVR...

Another possible reason why, for example, your stty misbehaves, maybe it 
is somehow broken in that distro? I am just using etch and things work 
pretty well.

Thanks
Guennadi
---
Guennadi Liakhovetski
