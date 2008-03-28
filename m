Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbYC1AG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbYC1AG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYC1AGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:06:44 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1067 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbYC1AGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:06:42 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: tg3 bad performance, lots of hardware interrupts
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: harald@iki.fi, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <20080327.144925.196529669.davem@davemloft.net>
References: <alpine.DEB.1.00.0803271532570.30549@penti.org>
 <20080327.144925.196529669.davem@davemloft.net>
Date: Thu, 27 Mar 2008 17:01:38 -0800
Message-ID: <1206666100.5368.6.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6BF2E90941K21659086-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 14:49 -0700, David Miller wrote:
> From: Harald Hannelius <harald@iki.fi>
> Date: Thu, 27 Mar 2008 15:53:56 +0200 (EET)
> 
> > I experience a lot of hardware interrupts with a BCM5751 PCI-express NIC 
> > (tg3). modprobe tg3, ifconfig ethX up and friends makes the system 
> > unresponsive. Just having the interface up makes the system sluggish.
> > 

I just tested a similar NIC using the same kernel and driver, but I did
not notice anything unusual.  netperf gave me 941Mbps.

> > Onboard forcedeth works fine (with the same cable).
> > 
> > iperf gives me just 2Mbps on a 1Gbps ethernet. Load average near 1.0. top 
> > reports 40-50%hi (hardware interrupts) when generating traffic over that 
> > interface.

Can you look at /proc/interrupts to see roughly how many are reported
per second when link is down, link is up with no traffic, and with
traffic?

Finally, you can also try ethtool -t eth0 to see if it passes a simple
self test.

