Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbXKGWd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbXKGWd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbXKGWdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:33:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47801 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbXKGWdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:33:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heikki Orsila <shdl@zakalwe.fi>
Subject: Re: net: skge breakage on 2.6.24-rc1
Date: Wed, 7 Nov 2007 23:50:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20071107214621.GA8865@zakalwe.fi> <20071107215348.GB8865@zakalwe.fi>
In-Reply-To: <20071107215348.GB8865@zakalwe.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711072350.30645.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 7 of November 2007, Heikki Orsila wrote:
> On Wed, Nov 07, 2007 at 11:46:21PM +0200, Heikki Orsila wrote:
> > After some bisecting, I found that net skge driver broke on
> > 
> > commit 7fb7ac241162dc51ec0f7644d4a97b2855213c32
> > 
> > My network card is:
> > 
> > 0000:00:0e.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T [Marvell] (rev 12)
> > 
> > Linux cheradenine 2.6.24-rc1-dirty #15 Wed Nov 7 23:39:28 EET 2007 x86_64 GNU/Linux
> 
> Sorry, forgot to say what the problem is. Doing
> 
> 	nc host port < /dev/zero
> 
> on a sending machine (not skge) to an skge machine that is receiving:
> 
> 	nc -l -p port >/dev/null
> 
> with ~60 MiB/s speed, causes the interface go malfunct. A slow 
> transfer doesn't cause a problem.
> 
> Also, after some fiddling, I noticed that not changing the register 
> write order on patch:
> 
> +       skge_write32(hw, RB_ADDR(q, RB_END), end);
>         skge_write32(hw, RB_ADDR(q, RB_WP), start);
>         skge_write32(hw, RB_ADDR(q, RB_RP), start);
> -       skge_write32(hw, RB_ADDR(q, RB_END), end);
> 
> fixes the visible effect.. Possibly not the root cause of the problem, 
> but changing the order back fixes networking here.

Please put all of the relevant information into the bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=9321

Thanks,
Rafael
