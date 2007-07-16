Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbXGPR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbXGPR7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 13:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXGPR7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 13:59:23 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:48279 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbXGPR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 13:59:21 -0400
From: Markus <lists4me@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v19
Date: Mon, 16 Jul 2007 19:59:17 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070706173319.GA2356@elte.hu> <200707141711.25272.lists4me@web.de> <20070716094158.GA19491@elte.hu>
In-Reply-To: <20070716094158.GA19491@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707161959.17750.lists4me@web.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18mpLsFUxf5HbGt4BnKwrZoBA25nYG829LSeX2K
	pQIJ/pBFrXw/miDaMPwJ7TPqBU25xfPyaSFPXsPIOcNiwCW47o
	+vdBr1FCc=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > [...] The mouse is smooth, just when one app is being quit (dont 
> > know why...) the mouse will be jerking for a few seconds...
> is the mouse jerky on any app quitting?
No.

> Or is your observation the  following: _sometimes_ apps quit 
> unexpectedly (their window just vanishes?), and _at the same time_,
> the mouse becomes jerky as well, for a few seconds?
Exactly.

> the mouse typically only becomes jerky when there's some really high 
> load on the system - anything else would be a kernel bug. A jerky
> mouse on an unloaded system is definitely a sign of some sort of
> kernel bug  (in or outside of the scheduler). An app vanishing
> unexpectedly might mean an OOM-kill - but that would should up in the
> syslog as well.    
> Pretty weird.
Well, the system uses about 30% of the cpu (cool'n'quite put it on the 
lowest frequency).

I made a plain 2.6.22.1 and could use it for about 2 hours without 
any problem. Then I applied the cfs-v19 for that kernel, rebuild from 
mrproper with the saved config and booted. After a few minutes the 
first app vanished... some more followed by time (I just surfed around 
a bit...)

The dmesg output is not differing in any interesting point (just some 
numbers, like raid-benchmark, some irqs or usb-numbers...)

So its obviously something within cfs... unfortunately...

> Can you make this regression trigger arbitrarily, so that we could
> debug it better? Apps exiting unexpectedly can be debugged via: 
> 
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/vdso-print-fatal-signals.patch
> 
> you can turn it on via the print-fatal-signals=1 boot option or via:
> 
>   echo 1 > /proc/sys/kernel/print-fatal-signals
> 
> this feature will produce a small dump to the syslog about every app 
> that exits unexpectedly. Note that this might not cover all types of 
> "window suddenly vanishes" regressions.
Nothing is printed for a disapeared app for me.


Is there anything more I can try?


   Markus
