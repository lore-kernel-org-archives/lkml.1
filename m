Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169Ab0ARVu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab0ARVu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027Ab0ARVu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:50:57 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63847 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0ARVuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:50:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mj5mGGBzF4UX0DgsoZ0eWzV2umgCjr3DRJa7wAAdXDs7EvG6UDhxbc5FMQqYZOMZ7g
         DlLAKfaofsMt+1qObII71NFTqlPzLQ5qtkXZw3RkTJuG3cXTqYAyTuzwfiUFl32+tZo9
         AGVnU/Eh4cAZok66AhrFyeT2jRS673CqGeh3g=
Date: Mon, 18 Jan 2010 22:50:48 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118215048.GF3157@del.dom.local>
References: <20100117221746.GA3161@del.dom.local>
 <4B53906B.2020608@majjas.com>
 <20100117230531.GC3161@del.dom.local>
 <4B539A0A.2000504@majjas.com>
 <20100118073018.GA6270@ff.dom.local>
 <4B548C6B.10607@majjas.com>
 <20100118204658.GC3157@del.dom.local>
 <4B54CB0D.5070604@majjas.com>
 <20100118130038.77a3adfb@nehalam>
 <4B54D1A4.2020609@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B54D1A4.2020609@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 04:24:52PM -0500, Michael Breuer wrote:
> On 1/18/2010 4:00 PM, Stephen Hemminger wrote:
> >On Mon, 18 Jan 2010 15:56:45 -0500
> >Michael Breuer<mbreuer@majjas.com>  wrote:
> >
> >>>>2. The dropped tx packet (DHCP) is a bit harder to recreate, but it
> >>>>still happens.
> >>>>
> >You might want to use tc filter rule to set priority of DHCP packets
> >higher. This would cause them to be in a separate queue and eliminate
> >the problem.
> >
> Ok - for fun, tried that - no change. Not sure I see why this might
> be a factor. The packet loss happens when TX load is low and RX
> high.
> Also,  packets only being dropped if traversing a router vs.to  the
> router itself.  Keep in mind that pings to the router did not lose
> packets, pings through the router lost packets. The router was not
> under load (traffic is being generated from a device connected via
> the 1Gb switch, not the wifi router), and tcpdump on the router
> input port shows the pings to the router, but not the ones through
> the router.
> 
> One added note, when I just tried this, the test data ended while
> the packet loss was occurring. The DHCPOFFER packet loss did not
> clear until about a minute after the throughput abated. I really
> think something is getting hosed, and I'd but some weird interaction
> with the arp logic high on the list of suspects. Not sure what else
> would be a factor when looking at the extra hop on the same subnet.

Good point! Actually, IIRC, your setup might be a problem: you seem
to have two switches on the path (I guess the router is a bridge for
these wireless), so I wonder if it's not something between them.

Jarek P.
