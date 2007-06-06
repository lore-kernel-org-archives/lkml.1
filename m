Return-Path: <linux-kernel-owner+w=401wt.eu-S936333AbXFFXWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333AbXFFXWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbXFFXVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:21:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37834
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbXFFXVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:21:54 -0400
Date: Wed, 06 Jun 2007 16:22:10 -0700 (PDT)
Message-Id: <20070606.162210.35662366.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG sparc64] 2.6.22-rc broke X on Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070530.130140.97293476.davem@davemloft.net>
References: <200705301933.l4UJXIE0023913@alkaid.it.uu.se>
	<20070530.130140.97293476.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 30 May 2007 13:01:40 -0700 (PDT)

> From: Mikael Pettersson <mikpe@it.uu.se>
> Date: Wed, 30 May 2007 21:33:18 +0200 (MEST)
> 
> > You were spot on. 2.6.21 + patches up to but not including
> > the first one above works. Adding that one gave me a kernel
> > that wouldn't boot (hung after "uncompressing kernel").
> > Adding the second one above gave me a kernel that booted, but
> > where X failed to mmap() the frame buffer as I described.
> 
> Thanks for all of your testing.
> 
> I'll try to figure this out on one of my Ultra5's here.

So I did some more digging, got my ultra5 running and I can't
get it to work with both 2.6.20 and 2.6.22-rc4 :-)  This is
with xorg-7.2, and they both fail with:

xf86MapPciMem: Could not mmap ...

which I assume is the error you're seeing.

Investigation reveals that X.org is erroneously trying to
do PCI mmap ioctl()'s on /sys/bus/pci/devices/*/config
files which is very very wrong.  Again this happens for me
with both 2.6.20 and 2.6.22

Can you just quickly strace "Xorg" startup in the working
and non-working case?  Just a simple:

	strace -o x.log Xorg

would for both cases be fine.

You can email it to me privately, and I'll post here my
analysis with the relevant portions quoted so we don't
flood the list with strace dumps :-)

Thanks a lot!
