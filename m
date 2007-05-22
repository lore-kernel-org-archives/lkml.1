Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbXEVJFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbXEVJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbXEVJFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:05:33 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36874
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbXEVJFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:05:32 -0400
Date: Tue, 22 May 2007 02:05:34 -0700 (PDT)
Message-Id: <20070522.020534.07643900.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG sparc64] 2.6.22-rc broke X on Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18002.44181.639121.720839@alkaid.it.uu.se>
References: <18002.44181.639121.720839@alkaid.it.uu.se>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Tue, 22 May 2007 10:40:53 +0200

> 2.6.21 works fine on my Ultra5, but with 2.6.22-rc the X
> server (from Aurora 2) fails to mmap() the PCI frame buffer
> (atyfb).
> 
> I noticed a lot of PCI-related changes both in `dmesg' and
> /var/log/Xorg.0.log between 2.6.21 and 2.6.22-rc, so my
> guess is that PCI resources get broken somewhere.
> 
> I'll try a bisect between 2.6.21 and 2.6.22-rc1 next, but
> I'm also willing to test patches in case anyone thinks they
> know what the fix is.

Start your bisect with the change right before this one:

commit a2fb23af1c31ad6e0c281e56d385f803229d57fa
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Wed Feb 28 23:35:04 2007 -0800

    [SPARC64]: Probe PCI bus using OF device tree.
    
    Almost entirely taken from the 64-bit PowerPC PCI code.
    
    This allowed to eliminate a ton of cruft from the sparc64
    PCI layer.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

Unfortunately, if the tree works right before this change,
you can't just add this one because a subsequent fix is
needed before ultra5/ultra10 will work again, but it's
this one:

commit 01f94c4a6ced476ce69b895426fc29bfc48c69bd
Author: David S. Miller <davem@ultra5.davemloft.net>
Date:   Sun Mar 4 12:53:19 2007 -0800

    [SPARC64]: Fix sabre pci controllers with new probing scheme.
 ...

So you could test these two commits:

deb66c4521e119442aa266553e8cbfc86eb71232
a2fb23af1c31ad6e0c281e56d385f803229d57fa

Thanks.
