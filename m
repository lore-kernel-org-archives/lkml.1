Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbXKLXkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbXKLXkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758030AbXKLXkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:40:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:3057 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbXKLXkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:40:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,407,1188802800"; 
   d="scan'208";a="269129426"
Message-ID: <4738E404.8020105@intel.com>
Date: Mon, 12 Nov 2007 15:38:44 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: David Miller <davem@davemloft.net>, cfriesen@nortel.com, kaber@trash.net,
       joonwpark81@gmail.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
References: <4738D70C.4060404@nortel.com> <20071112.145716.06352378.davem@davemloft.net> <20071112231516.GA15227@1wt.eu> <20071112.151923.77768525.davem@davemloft.net> <20071112233257.GA15524@1wt.eu>
In-Reply-To: <20071112233257.GA15524@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2007 23:39:05.0476 (UTC) FILETIME=[3677D440:01C82585]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> On Mon, Nov 12, 2007 at 03:19:23PM -0800, David Miller wrote:
>> From: Willy Tarreau <w@1wt.eu>
>> Date: Tue, 13 Nov 2007 00:15:16 +0100
>>
>>> I can say that sometimes you'd like to be aware that one of your
>>> VLANs is wrong and you'd simply like to sniff the wire to guess the
>>> correct tag. And on production, you simply cannot remove other
>>> VLANs, otherwise you disrupt the service.
>> If you were plugged into the wrong physical switch, how might
>> you debug that problem in production? :-)
> 
> tcpdump on an unfiltered RJ45 tells you a lot of things. Some switches
> for instance send keepalive packets (ether proto 9000) with their own
> MAC as source+dest, others send CDP packets, etc... I've very rarely
> stayed plugged to the wrong switch for too long before discovering it.
> But that requires the ability to sniff.
> 
>> Really, it's the same issue, just virtualized, as in the name
>> for the feature, VLAN.
> 
> No, it's not the same, because as soon as you pass through a switch
> which is not configured for VLANs, it does not make any distinction,
> and the same DMAC is considered on a single port whatever the VLAN.
> This is not true with multiple switches. Also, sometimes, being able
> to see that your port gets flooded with traffic for a VLAN on which
> you're not configured helps you understand why you cannot fill the
> port.
> 
> I'd like that we can use the hardware correctly without having to
> buy TAPs. It reminds me the discussions about TOE. You claim
> yourself that TOE is bad in part because you have little if any
> control on the bugs on the TCP stack on the chip. This is the same
> here. If I know that the chip does not send me what it receives
> when configured in promiscuous mode, I can I swear it never received
> the missing packet ? There's always a doubt. Maybe sometimes the
> filter is buggy, maybe it only passes tags when the remaining bits
> are all zero, etc... Promiscuous mode generally means that you're
> the closest possible to the wire. We already do not receive pause
> frames and sometimes that's annoying. But having no control over
> what we want to see is frustrating.
> 
> At least, being able to disable the feature at module load time
> would be acceptable. Many people who often need to sniff on decent
> machines would always keep it disabled.

I really do not want to add another module parameter to the driver for this. It
seems bogus as well: if we can agree on one sane choice it's much better, and if
we don't then we should use ethtool to provide a uniform way of implementing this
for all drivers sanely.

Auke
