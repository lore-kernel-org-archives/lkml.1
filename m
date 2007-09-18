Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbXIRPGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbXIRPGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbXIRPGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:06:37 -0400
Received: from main.gmane.org ([80.91.229.2]:50198 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbXIRPGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:06:36 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: PROBLEM: Network sky2 Module
Date: Tue, 18 Sep 2007 08:05:25 -0700
Organization: Linux Foundation
Message-ID: <20070918080525.7a49d110@freepuppy.rosehill.hemminger.net>
References: <46E2BC6A.4070800@gmx.de>
	<46EF4DE1.4000707@soo.com>
	<46EFE09B.6090901@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <46EFE09B.6090901@tmr.com>
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 10:28:43 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> ben soo wrote:
> > i'm experiencing this problem myself.  i have 2 servers, one using 
> > X86_64 kernel version 2.6.23-rc5 on a 100Mbit network and one with i386 
> > kernel version 2.6.23-rc6 on a 1Gbit network.
> > 
> > They both have this issue with the sky2 network device driver whereby 
> > the device would stop working and need to be brought down and back up.
> > 
> > On the X86_64 kernel on a 100Mbit network, this is a very occasional 
> > thing, while on the i386 kernel on a 1Gbit network the device only works 
> > for a few minutes at a time.  If i set the MTU to 7200 then the device 
> > seems to stay functional, but then i see long delays when it's talking 
> > to 100Mbit devices with standard 1500 MTU that are outside of its LAN 
> > segment.
> > 
> > This last might be an artifact caused by the firewall, i dunno.
> > 
> Yes, I have found that I get far less problem in this area leaving the 
> MTU at 1500, then putting a larger MTU (usually 9000) into the routing 
> table for segments, or even just machines, where I know there is direct 
> connectivity. I use 9000 MTU with my directly connected file server, 
> 1500 elsewhere. I can go to 9000 for nbd servers as well, assuming the 
> connection doesn't pass a firewall.
> 
> I have some hints that while the switches I use will speak 10/100/1000 
> between machines with different speeds, and will handle jumbo packets 
> between machines at the same speed, if I'm going Gbit/jumbo to 
> 1500/slower performance seems to suffer more than talking smaller 
> packets. That may be because window size needs to be even larger or 
> something.
> 
> I have some legacy machines talking 10Mbit/half on 10base2 cable, I may 
> be seeing more of this than the average site. That's legacy as in 
> "attached to something expensive to replace."
> 

If you want to use Jumbo frames, you need to have routers and firewalls
that correctly handle ICMP and do path MTU discovery. If you have bridges
or firewalls that aren't Jumbo aware on both interfaces, then there will
be long timeouts retries for each connection. If you have busted routers
and firewalls that swallow ICMP then PMTU won't work well either.


-- 
Stephen Hemminger <shemminger@linux-foundation.org>

