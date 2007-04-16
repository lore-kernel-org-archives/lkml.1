Return-Path: <linux-kernel-owner+w=401wt.eu-S965105AbXDPJbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105AbXDPJbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 05:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965153AbXDPJbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 05:31:08 -0400
Received: from tim.rpsys.net ([194.106.48.114]:56967 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105AbXDPJbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 05:31:06 -0400
Subject: Re: [2/2] 2.6.21-rc7: known regressions
From: Richard Purdie <rpurdie@rpsys.net>
To: Dave Jones <davej@redhat.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20070416075543.GB15281@redhat.com>
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org>
	 <20070416003723.GM3691@stusta.de> <20070416005446.GB21217@redhat.com>
	 <20070416011636.GO3691@stusta.de> <20070416062921.GB7528@redhat.com>
	 <1176706447.5129.6.camel@daplas> <20070416072326.GA15281@redhat.com>
	 <1176708722.5129.8.camel@daplas>  <20070416075543.GB15281@redhat.com>
Content-Type: text/plain
Date: Mon, 16 Apr 2007 10:26:43 +0100
Message-Id: <1176715603.6794.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-16 at 03:55 -0400, Dave Jones wrote: 
> On Mon, Apr 16, 2007 at 03:32:02PM +0800, Antonino A. Daplas wrote:
>  > On Mon, 2007-04-16 at 03:23 -0400, Dave Jones wrote:
>  > > On Mon, Apr 16, 2007 at 02:54:07PM +0800, Antonino A. Daplas wrote:
>  > >  
>  > >  > CONFIG_ACPI_VIDEO depends on BACKLIGHT_CLASS_DEVICE, which, in turn is
>  > >  > enabled by FB_BACKLIGHT. So we can narrow it down further, can you try?
>  > >  > 
>  > >  > CONFIG_FB_BACKLIGHT=y
>  > >  > CONFIG_ACPI_VIDEO=n
>  > > 
>  > > That also gets me a dead display. Backlight doesn't turn back on.
>  > 
>  > Anything under /sys/class/backlight?
> 
> Entries from ibm_acpi.  I rmmod'd that, leaving the dir empty,
> and it still fails.

What happens if you never load ibm-acpi?

I'm a bit puzzled as CONFIG_FB_BACKLIGHT doesn't do anything with the
intelfb driver. One thing it does do is set
CONFIG_BACKLIGHT_CLASS_DEVICE. When you disabled FB_BACKLIGHT and got a
working display on resume, was that set and was (or had) ibm-acpi been
loaded?

A variety of other options such as ACPI_IBM also set
CONFIG_BACKLIGHT_CLASS_DEVICE although without a backlight driver it
will do nothing hence the suspicion is on ibm-acpi, perhaps interacting
with the backlight class badly.

Does echoing numbers to /sys/class/backlight/ibm_acpi/brightness change
the backlight brightness as expected? If you can ssh into the machine
after its resumed with the display problem, it would be interesting to
know what the brightness was and if changing it helped too...

Regards,

Richard

