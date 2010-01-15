Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0AOL31 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856Ab0AOL30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:29:26 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:12500 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab0AOL3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:29:25 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Brian Gerst <brgerst@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1001150011480.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de>
	 <4B4405B5.9040205@goop.org>
	 <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
	 <20100106112133.GA5815@lenovo>
	 <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de>
	 <4B4633D3.2070903@zytor.com>
	 <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de>
	 <20100108215039.GD4967@lenovo>
	 <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>
	 <20100110080940.GB5189@lenovo>
	 <1263128343.2393.45.camel@cthulhu.hellion.org.uk>
	 <alpine.DEB.2.01.1001150011480.3483@bogon.housecafe.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 11:29:10 +0000
Message-ID: <1263554950.16526.27033.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=1ggfb5FlKZQUfF3vzm9UBYZ2uTfLsbs/8dSljwg5+mE= c=1 sm=0 a=WUDd807v63sA:10 a=L9emPyK8aKtpWj3li3QA:9 a=GjrKZu5u8N1tQdJc0pMpGc_ueloA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-15 at 00:36 -0800, Christian Kujau wrote:
> On Sun, 10 Jan 2010 at 12:59, Ian Campbell wrote:
> > The correct fix is for the Xen backend to declare kernel RPL == 0 for 64
> > bit guests -- the hyervisor already takes care of all the necessary
> > squashing to ring 3 transparently (because making the guest worry about
> > it would break the very common assumption that you can distinguish user
> > from kernel CS by RPL).
> 
> Yes' it's a 64bit guest, I should have mentioned this from the beginning. 

That's OK, I already knew because only 64 bit guests have a separate
user page table.

> With the 2 patches from Ian and Cyrill applied, the DomU is now booting 
> fine again (currently running mainline -git).

Excellent. These patches are both now in -tip. They are in the urgent
branch so I assume they will be heading to mainline before too long.

> Cyrill: with your patch alone (for arch/x86/kernel/process.c), the DomU
> is still not booting, Dom0 "xm dmesg" reporting the same error. As it's
> working with both patches applied, should I try to test with only Ian's
> patch (for arch/x86/xen/enlighten.c) applied?

It's OK, both patches are definitely required to fix 64 bit guests so
there is no point in testing just one or the other.

Ian.

-- 
Ian Campbell
Current Noise: Exodus - Scar Spangled Banner

War is much too serious a matter to be entrusted to the military.
		-- Clemenceau

