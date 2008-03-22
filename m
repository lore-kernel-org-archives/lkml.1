Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYCVWqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYCVWqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 18:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYCVWqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 18:46:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753601AbYCVWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 18:46:16 -0400
Date: Sat, 22 Mar 2008 15:46:27 -0700 (PDT)
Message-Id: <20080322.154627.54355549.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jesper.juhl@gmail.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080321.222125.245725675.davem@davemloft.net>
References: <20080321.171401.49157146.davem@davemloft.net>
	<adalk4bv62r.fsf@cisco.com>
	<20080321.222125.245725675.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Fri, 21 Mar 2008 22:21:25 -0700 (PDT)

> From: Roland Dreier <rdreier@cisco.com>
> Date: Fri, 21 Mar 2008 19:35:40 -0700
> 
> >  > It makes a difference for driver maintainers when users
> >  > report bugs and we ask them for the version printed
> >  > by the driver so that we know which fixes have been
> >  > applied.
> > 
> > I'm not sure if this series of patches really accomplishes that...
> > you're leaving out some patches such as "[NIU]: Fix 1G PHY link state
> > handling." that are in the real 0.7.  So the 2.6.24.stable version 0.7
> > has a different set of fixes than the 2.6.25 version 0.7.
> 
> That was an oversight and not intentional, thanks for
> for catching that.

Actually Roland, that 1G fix you mention was put in during the
2.6.23 development series.

If you ask git for all the NIU driver changes since 2.6.24
you get:

davem@sunset:~/src/GIT/linux-2.6$ git log v2.6.24.. drivers/net/niu.[ch]
commit fa907895b7b776208a1406efe5ba7ffe0f49f507
Author: Matheos Worku <Matheos.Worku@Sun.COM>
Date:   Wed Feb 20 00:18:09 2008 -0800

    [NIU]: More BMAC alt MAC address fixes.
    
    From: Matheos Worku <Matheos.Worku@Sun.COM>
    
    1) niu_enable_alt_mac() needs to be adjusted so that the mask
       is computed properly for the BMAC case.
    
    2) BMAC has 6 alt MAC addresses available, not 7.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit a442585952f137bd4cdb1f2f3166e4157d383b82
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Feb 18 21:30:48 2008 -0800

    [NIU]: Bump driver version and release date.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 3b5bcedeeb755b6e813537fcf4c32f010b490aef
Author: Matheos Worku <matheos.worku@sun.com>
Date:   Mon Feb 18 21:30:03 2008 -0800

    [NIU]: Fix BMAC alternate MAC address indexing.
    
    BMAC port alternate MAC address index needs to start at 1. Index 0 is
    used for the main MAC address.
    
    Signed-off-by: Matheos Worku <matheos.worku@sun.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

commit 2caf62f6cae46e36b1c4a1b0f2d9ef82af89cad2
Author: Joe Perches <joe@perches.com>
Date:   Thu Dec 20 04:07:35 2007 -0800

    [NIU]: Use print_mac
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
davem@sunset:~/src/GIT/linux-2.6$ 

Since using print_mac is a one-liner cleanup rather than a bug fix,
it's reasonable to leave it out for 2.6.24-stable

What's left is exactly what I submitted for -stable.
