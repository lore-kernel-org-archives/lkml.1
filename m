Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbXIROZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbXIROZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 10:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbXIROZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 10:25:05 -0400
Received: from mail.tmr.com ([64.65.253.246]:51474 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbXIROZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 10:25:03 -0400
Message-ID: <46EFE09B.6090901@tmr.com>
Date: Tue, 18 Sep 2007 10:28:43 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: lnx-kern@soo.com
CC: Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Network sky2 Module
References: <46E2BC6A.4070800@gmx.de> <46EF4DE1.4000707@soo.com>
In-Reply-To: <46EF4DE1.4000707@soo.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ben soo wrote:
> i'm experiencing this problem myself.  i have 2 servers, one using 
> X86_64 kernel version 2.6.23-rc5 on a 100Mbit network and one with i386 
> kernel version 2.6.23-rc6 on a 1Gbit network.
> 
> They both have this issue with the sky2 network device driver whereby 
> the device would stop working and need to be brought down and back up.
> 
> On the X86_64 kernel on a 100Mbit network, this is a very occasional 
> thing, while on the i386 kernel on a 1Gbit network the device only works 
> for a few minutes at a time.  If i set the MTU to 7200 then the device 
> seems to stay functional, but then i see long delays when it's talking 
> to 100Mbit devices with standard 1500 MTU that are outside of its LAN 
> segment.
> 
> This last might be an artifact caused by the firewall, i dunno.
> 
Yes, I have found that I get far less problem in this area leaving the 
MTU at 1500, then putting a larger MTU (usually 9000) into the routing 
table for segments, or even just machines, where I know there is direct 
connectivity. I use 9000 MTU with my directly connected file server, 
1500 elsewhere. I can go to 9000 for nbd servers as well, assuming the 
connection doesn't pass a firewall.

I have some hints that while the switches I use will speak 10/100/1000 
between machines with different speeds, and will handle jumbo packets 
between machines at the same speed, if I'm going Gbit/jumbo to 
1500/slower performance seems to suffer more than talking smaller 
packets. That may be because window size needs to be even larger or 
something.

I have some legacy machines talking 10Mbit/half on 10base2 cable, I may 
be seeing more of this than the average site. That's legacy as in 
"attached to something expensive to replace."

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
