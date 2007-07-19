Return-Path: <linux-kernel-owner+w=401wt.eu-S939504AbXGSQe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939504AbXGSQe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765729AbXGSQeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:34:15 -0400
Received: from stinky.trash.net ([213.144.137.162]:38161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765749AbXGSQeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:34:13 -0400
Message-ID: <469F924B.2090901@trash.net>
Date: Thu, 19 Jul 2007 18:33:15 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: andrei radulescu-banu <iubica2@yahoo.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: Linux, tcpdump and vlan
References: <123837.78916.qm@web56604.mail.re3.yahoo.com>
In-Reply-To: <123837.78916.qm@web56604.mail.re3.yahoo.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

andrei radulescu-banu wrote:
> The consensus seems to be that skb's need to carry vlan accelerated tags in their cb's, on rx as well as tx. VLAN_TX_SKB_CB() is perfect for that.


No its not. Its only legal to use while something has ownership
of the skb. Between VLAN devices and real devices qdiscs are
free to use it.

>>[Patrick] On the TX path, it could simply use the CB, but this is actually
> 
> also wrong (for both macvlan and real devices) since qdiscs have
> ownership of the skb in between, and at least netem *does* modify
> the CB, breaking VLAN.
> 
> Thanks for pointing that out... It appears to me that qdisc/netem already breaks the vlan implementation, in the path 
> 
> vlan_dev_hwaccel_hard_start_xmit(): sets accelerated vlan tag in skb->cb, calls
> dev_queue_xmit(): may pass skb to qdisc/netem, which may mangle skb->cb before calling
> dev->hard_start_xmit(), resulting in a tx frame without its vlan tag.
> 
> So netem needs to look for hw accelerated vlan metadata and insert it in the skb... Don't see any other way around this. 


No, we might want to put other data in the cb in the future.
VLAN should follow the rules instead.
