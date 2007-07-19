Return-Path: <linux-kernel-owner+w=401wt.eu-S1765167AbXGSXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765167AbXGSXjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbXGSXjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:39:11 -0400
Received: from ns2.lanforge.com ([66.165.47.211]:33816 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635AbXGSXjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:39:09 -0400
Message-ID: <469FF611.6080905@candelatech.com>
Date: Thu, 19 Jul 2007 16:38:57 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: andrei radulescu-banu <iubica2@yahoo.com>
CC: Patrick McHardy <kaber@trash.net>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Linux, tcpdump and vlan
References: <930446.33248.qm@web56601.mail.re3.yahoo.com>
In-Reply-To: <930446.33248.qm@web56601.mail.re3.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

andrei radulescu-banu wrote:
> During debugging, I noticed that dev_queue_xmit() is called twice for tx vlan frames. This results in a frame being passed twice to a packet socket bound to 'any' interface. If the packet socket is bound to a specific interface, though, it will get only one copy of the tx frame, which is good.
> 
> In more detail: suppose we're tx'ing a frame, and the route table lookup yields a vlan outgoing device eth0.2. dev_queue_xmit() is called, which calls dev_queue_xmit_nit() for dev = eth0.2 then dev->hard_start_xmit() for dev = eth0.2. 
> 
> The latter call gets into the vlan layer, which attaches the vlan id 2 (accelerated or not... in my e1000 case accelerated) then calls dev_queue_xmit() again. This time around dev_queue_xmit_nit() is called for dev = eth0, and dev->hard_start_xmit() actually calls the ethernet driver.
> 
> The net result is that dev_queue_xmit_nit() is called twice, once for dev=eth0.2 then for dev=eth0.

Maybe binding to all isn't such a good idea then.

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

