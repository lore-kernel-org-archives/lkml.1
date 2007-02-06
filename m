Return-Path: <linux-kernel-owner+w=401wt.eu-S965418AbXBFAwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965418AbXBFAwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965415AbXBFAwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:52:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965418AbXBFAwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:52:35 -0500
Date: Mon, 5 Feb 2007 16:52:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Daniel Barkalow <barkalow@iabervon.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Ayaz Abdulla <aabdulla@nvidia.com>
Subject: Re: forcedeth problems on 2.6.20-rc6-mm3
Message-Id: <20070205165224.df923c78.akpm@linux-foundation.org>
In-Reply-To: <45C7CD3A.808@shaw.ca>
References: <45C6BCE5.90103@shaw.ca>
	<Pine.LNX.4.64.0702050124320.20138@iabervon.org>
	<45C7CD3A.808@shaw.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Feb 2007 18:35:06 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Daniel Barkalow wrote:
> > On Sun, 4 Feb 2007, Robert Hancock wrote:
> > 
> >> Something's busted with forcedeth in 2.6.20-rc6-mm3 for me relative to
> >> 2.6.20-rc6. There's no errors in dmesg, but it seems no packets ever get
> >> received and so the machine can't get an IP address. I tried reverting all the
> >> -mm changes to drivers/net/forcedeth.c, which didn't help. The network
> >> controller shares an IRQ with the USB OHCI controller which is receiving
> >> interrupts, so it doesn't seem like an interrupt routing problem, though I
> >> suppose something wierd could be happening there.
> > 
> > IIRC, forcedeth tries to use MSI by default. Perhaps the hardware is using 
> > it, but the kernel thinks enabling it didn't work? I think there's a 
> > module option for forcedeth to disable MSI, which might be worth a try to 
> > see if it has any effect.
> 
> I must have messed something up when testing before - reverting to 
> forcedeth.c from 2.6.20-rc6 does indeed fix the problem. And it doesn't 
> seem like no packets at all are received with the -mm3 version (driver 
> version 0.60), either - if I do a tcpdump I can get Ethernet packets 
> showing up, but I can't ping my router so it seems like something isn't 
> getting through properly. With the 2.6.20-rc6 version (driver version 
> 0.59) it works fine. I switched back and forth between versions and this 
> seems repeatable.
> 
> I don't think it's MSI related, the CK804 version of these controllers 
> doesn't support MSI and the driver shouldn't be trying to use it. I 
> tried the MSI and MSI-X disable options on the 0.60 driver, but that 
> didn't help.
> 

OK, thanks.  Jeff, please note that the forcedeth changes in git-netdev-all
have a problem.
