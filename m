Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbXFIJnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbXFIJnR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 05:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbXFIJnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 05:43:07 -0400
Received: from mail.asoft.ru ([83.222.19.8]:57459 "EHLO mail.asoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbXFIJnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 05:43:05 -0400
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Jun 2007 05:43:05 EDT
Date: Sat, 9 Jun 2007 13:18:04 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: David Miller <davem@davemloft.net>
Cc: mikpe@it.uu.se, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG sparc64] 2.6.22-rc broke X on Ultra5
Message-ID: <20070609091804.GA3793@sunflower.office.asoft.ru>
References: <200705301933.l4UJXIE0023913@alkaid.it.uu.se> <20070530.130140.97293476.davem@davemloft.net> <20070606.162210.35662366.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606.162210.35662366.davem@davemloft.net>
X-HackerKey: v2sw4CUhw5/6ln5pr2ck4ma6u7Lw2Xm4l7Fi2e3t4MBb6HTen4g4RACa2Xs4r5p3 hackerkey.com
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0.2 (mail.asoft.ru [0.0.0.0]); Sat, 09 Jun 2007 13:18:19 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good day!

Sorry for intruding, but I'm seeing the same problem on my U10 with 
2.6.22-rc3 and Xorg-7.1+gentoo patches.

On Wed, Jun 06, 2007 at 04:22:10PM -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 30 May 2007 13:01:40 -0700 (PDT)
> 
> > From: Mikael Pettersson <mikpe@it.uu.se>
> > Date: Wed, 30 May 2007 21:33:18 +0200 (MEST)
> > 
> > > You were spot on. 2.6.21 + patches up to but not including
> > > the first one above works. Adding that one gave me a kernel
> > > that wouldn't boot (hung after "uncompressing kernel").
> > > Adding the second one above gave me a kernel that booted, but
> > > where X failed to mmap() the frame buffer as I described.
> > 
> > Thanks for all of your testing.
> > 
> > I'll try to figure this out on one of my Ultra5's here.
> 
> So I did some more digging, got my ultra5 running and I can't
> get it to work with both 2.6.20 and 2.6.22-rc4 :-)  This is
> with xorg-7.2, and they both fail with:
> 
> xf86MapPciMem: Could not mmap ...
> 
> which I assume is the error you're seeing.
> 
> Investigation reveals that X.org is erroneously trying to
> do PCI mmap ioctl()'s on /sys/bus/pci/devices/*/config
> files which is very very wrong.  Again this happens for me
> with both 2.6.20 and 2.6.22

Xorg-7.2 (to be more precise, xorg-server-1.2.0) never worked for me, you 
can see my bug on gentoo bugzilla for more info:
http://bugs.gentoo.org/show_bug.cgi?id=167052
But Xorg-7.1 worked fine on kernels up and including 2.6.21

> 
> Can you just quickly strace "Xorg" startup in the working
> and non-working case?  Just a simple:
> 
> 	strace -o x.log Xorg
> 
> would for both cases be fine.
> 
> You can email it to me privately, and I'll post here my
> analysis with the relevant portions quoted so we don't
> flood the list with strace dumps :-)
> 
> Thanks a lot!

I sent David privately my .configs , Xorg.0.logs and strace logs for 2.6.21 
and 2.6.22-rc3. Hope it helps.

--
Best regards,
Dmitry 'MAD' Artamonow
