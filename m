Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYDGIOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYDGIOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753908AbYDGIO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:14:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38883 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbYDGIOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:14:25 -0400
Message-ID: <47F9D7BA.6080708@garzik.org>
Date: Mon, 07 Apr 2008 04:13:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, magnus.damm@gmail.com,
       damm@igel.co.jp, lethal@linux-sh.org, nico@cam.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: Blackfin STAMP537 compiling error in 2.6.25-rc8
References: <386072610804070057w1eb65db5taeca77f8f3e36627@mail.gmail.com>
In-Reply-To: <386072610804070057w1eb65db5taeca77f8f3e36627@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> We found the latest kernel compile failed with Blackfin STAMP537
> configuration on our daily build machine.
> ---
>   CC      drivers/net/smc91x.o
> drivers/net/smc91x.c: In function 'smc_rcv':
> drivers/net/smc91x.c:513: warning: passing argument 1 of 'insw' makes
> integer from pointer without a cast
> drivers/net/smc91x.c: In function 'smc_hardware_send_pkt':
> drivers/net/smc91x.c:620: warning: passing argument 1 of 'outsw' makes
> integer from pointer without a cast
> drivers/net/smc91x.c:1859:32: error: macro "SMC_GET_MAC_ADDR" requires
> 2 arguments, but only 1 given
> drivers/net/smc91x.c: In function 'smc_probe':
> drivers/net/smc91x.c:1859: error: 'SMC_GET_MAC_ADDR' undeclared (first
> use in this function)
> drivers/net/smc91x.c:1859: error: (Each undeclared identifier is
> reported only once
> drivers/net/smc91x.c:1859: error: for each function it appears in.)
> make[2]: *** [drivers/net/smc91x.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> ---
> 
> That is because my -mm tree fixing bug patch:
> (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9e6db60825ef7e7999abc610ce256ba768e58162)
> was merged into mainline before the smc91x API change patch in -mm:
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/broken-out/smc91x-pass-along-private-data-v2.patch
> 
> Did I miss something here? or this patch is on the way before 2.6.25
> final release?

It looks like I missed something...  I thought akpm was going to send 
the patch for -mm in?

If not, let's revert this one...

	Jeff




