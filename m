Return-Path: <linux-kernel-owner+w=401wt.eu-S1758500AbXE3Tdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500AbXE3Tdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758108AbXE3Td2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:33:28 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64499 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758053AbXE3Td1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:33:27 -0400
Date: Wed, 30 May 2007 21:33:18 +0200 (MEST)
Message-Id: <200705301933.l4UJXIE0023913@alkaid.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: davem@davemloft.net, mikpe@it.uu.se
Subject: Re: [BUG sparc64] 2.6.22-rc broke X on Ultra5
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 02:05:34 -0700 (PDT), David Miller <davem@davemloft.net> wrote:
> From: Mikael Pettersson <mikpe@it.uu.se>
> Date: Tue, 22 May 2007 10:40:53 +0200
> 
> > 2.6.21 works fine on my Ultra5, but with 2.6.22-rc the X
> > server (from Aurora 2) fails to mmap() the PCI frame buffer
> > (atyfb).
> > 
> > I noticed a lot of PCI-related changes both in `dmesg' and
> > /var/log/Xorg.0.log between 2.6.21 and 2.6.22-rc, so my
> > guess is that PCI resources get broken somewhere.
> > 
> > I'll try a bisect between 2.6.21 and 2.6.22-rc1 next, but
> > I'm also willing to test patches in case anyone thinks they
> > know what the fix is.
> 
> Start your bisect with the change right before this one:
> 
> commit a2fb23af1c31ad6e0c281e56d385f803229d57fa
> Author: David S. Miller <davem@sunset.davemloft.net>
> Date:   Wed Feb 28 23:35:04 2007 -0800
> 
>     [SPARC64]: Probe PCI bus using OF device tree.
>     
>     Almost entirely taken from the 64-bit PowerPC PCI code.
>     
>     This allowed to eliminate a ton of cruft from the sparc64
>     PCI layer.
>     
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> Unfortunately, if the tree works right before this change,
> you can't just add this one because a subsequent fix is
> needed before ultra5/ultra10 will work again, but it's
> this one:
> 
> commit 01f94c4a6ced476ce69b895426fc29bfc48c69bd
> Author: David S. Miller <davem@ultra5.davemloft.net>
> Date:   Sun Mar 4 12:53:19 2007 -0800
> 
>     [SPARC64]: Fix sabre pci controllers with new probing scheme.

You were spot on. 2.6.21 + patches up to but not including
the first one above works. Adding that one gave me a kernel
that wouldn't boot (hung after "uncompressing kernel").
Adding the second one above gave me a kernel that booted, but
where X failed to mmap() the frame buffer as I described.

/Mikael
