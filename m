Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbXKHQJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbXKHQJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761351AbXKHQJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:09:18 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:11448 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761269AbXKHQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:09:16 -0500
Date: Thu, 8 Nov 2007 08:08:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Brownell <david-b@pacbell.net>, David Miller <davem@davemloft.net>,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: build #337 failed for 2.6.24-rc1-gb1d08ac In function
 `usbnet_set_settings':
Message-Id: <20071108080803.a2b1201d.randy.dunlap@oracle.com>
In-Reply-To: <20071108033010.GF26163@stusta.de>
References: <200711012024.57412.toralf.foerster@gmx.de>
	<200711021230.22588.david-b@pacbell.net>
	<20071102195517.GW30287@stusta.de>
	<200711071434.52607.david-b@pacbell.net>
	<20071107225232.GB26163@stusta.de>
	<20071108033010.GF26163@stusta.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007 04:30:10 +0100 Adrian Bunk wrote:

> On Wed, Nov 07, 2007 at 11:52:32PM +0100, Adrian Bunk wrote:
> > On Wed, Nov 07, 2007 at 02:34:52PM -0800, David Brownell wrote:
> > > > > But on the other hand, it seems that only the ASIX code will work
> > > > > right; the DM9601 and MCS7830 Kconfig is different/wrong.
> > > > 
> > > > I'm not seeing the problem.
> > > > 
> > > > Which configuration will be handled wrongly?
> > > 
> > > Notice how only the ASIX kconfig depended on NET_ETHERNET...
> > > since MII depends on NET_ETHERNET, and (last I knew) the
> > > reverse dependencies didn't capture the complete dependency
> > > tree, selecting only MII would leave out some stuff.
> > 
> > Except for one s390 net driver (I'll check why it's doing this) the 
> > NET_ETHERNET option does not influence what code is being generated - 
> > it's just a Kconfig-internal option allowing to disable a huge bunch
> > of drivers at once.
> 
> Damn, I shouldn't have only grep'ed under drivers/.
> 
> @davem:
> 
> Please look at net/ipv4/arp.c:arp_process()
> 
> Am I right that CONFIG_NET_ETHERNET=n and CONFIG_NETDEV_1000=y or 
> CONFIG_NETDEV_10000=y will not be handled correctly there?

I'd say yes, you are correct.

> And the best solution is to nuke all #ifdef's in this function and make 
> the code unconditionally available?



---
~Randy
