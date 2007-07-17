Return-Path: <linux-kernel-owner+w=401wt.eu-S935982AbXGQTwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935982AbXGQTwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbXGQTwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:52:05 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:44495 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbXGQTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:52:01 -0400
From: Markus <lists4me@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v19
Date: Tue, 17 Jul 2007 21:42:41 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20070706173319.GA2356@elte.hu> <200707171506.37886.lists4me@web.de> <20070717170628.GA6002@elte.hu>
In-Reply-To: <20070717170628.GA6002@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707172142.42008.lists4me@web.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/mo2HbS4/Qjs6yQqW/9XMT3BQKcEPwDBpeoxSN
	+G5ufthnc0/Ae4tDIbMv1xwc7tR43LSPT6V57wXtHLuPZh+io8
	ag+1AHRjc=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 9173  1184675906.194424 ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, 
0x7fff341af5c0)
> = -1 ENOTTY (Inappropriate ioctl for device) <0.000006>
> 9173  1184675906.194463 ioctl(2, SNDCTL_TMR_TIMEBASE or TCGETS, 
0x7fff341af5c0)
> = -1 ENOTTY (Inappropriate ioctl for device) <0.000004>
> 
> ? Are those -ENOTTY results normal?
Yes, I see it on any kernel.
 
> 9173  1184675906.155015 write(2, "In file 
kernel/qpixmap_x11.cpp, "..., 56) = 56 <0.000006>
> 9173  1184675906.155052 write(2, "QImage::convertDepth: Image is 
a"..., 44) = 44 <0.000004>
> 9173  1184675906.155169 gettimeofday({1184675906, 155179}, NULL) = 0 
<0.000006>
> 9173  1184675906.155249 write(11, "close(6f1c2f7):about:konqueror\n", 
31) = 31 <0.000032>
> 
> i think konqueror tried to say something here about an image problem?
Well, yes:
In file kernel/qpixmap_x11.cpp, line 633: Out of memory
QImage::convertDepth: Image is a null image
In file kernel/qpixmap_x11.cpp, line 633: Out of memory
QImage::convertDepth: Image is a null image
In file kernel/qpixmap_x11.cpp, line 633: Out of memory
QImage::convertDepth: Image is a null image
In file kernel/qpixmap_x11.cpp, line 633: Out of memory
QImage::convertDepth: Image is a null image
konqueror: Fatal IO error: client killed

And no, my 2 GB of RAM are not full:
$ free -m
             total       used       free     shared    buffers     
cached
Mem:          2012       1077        935          0         22        
441
-/+ buffers/cache:        612       1400
Swap:         2070          0       2070

> could you perhaps upload the strace to some webpage so that others can 
> take a look too?
hm, I dont have any webspace...

> it might also be good to add "-s 1000" to the strace command, so that 
we 
> can see the full messages that konqueror tried to log to some other 
> task, i.e.:
> 
>   strace -s 1000 -ttt -TTT -o trace.log -f <app>
> 
> and perhaps try to do a 'comparison' trace.normal.log as well, with 
> konqueror having no problems.
I now made some new strace logs:
- konq crash 251K
- Konq without crash on cfs 302K
- konq without crash on non-cfs 248K


   Markus
