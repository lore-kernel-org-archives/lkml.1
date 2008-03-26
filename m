Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbYCZMX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbYCZMX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 08:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbYCZMXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 08:23:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:57523 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbYCZMXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 08:23:47 -0400
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Meyer <thomas@m3y3r.de>, Ingo Molnar <mingo@elte.hu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Gary Hade <garyhade@us.ibm.com>
In-Reply-To: <20080326101450.GA9060@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org>
	 <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de>
	 <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu>
	 <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu>
	 <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de>
	 <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org>
	 <20080326101450.GA9060@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 23:17:44 +1100
Message-Id: <1206533864.10573.44.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 13:14 +0300, Ivan Kokshaysky wrote:
> 
> Yeah, it's resource issue for sure. The 00:1e.0 is a transparent
> bridge,
> so I blame commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f
> (PCI: remove transparent bridge sizing). It's wrong for two reasons:
> - we cannot ignore standard windows of a transparent bridge as they
>   always positive decode, so they are potential source of address
> conflicts;
> - that patch just broke whole bridge setup logic in unpredictable way.

The root of the problem is again HW vendors getting wild I think...

Some bridges are fully transparent, some have explicit decode windows
but are also transparent for whatever else and we definitely don't deal
with it.

Ben.


