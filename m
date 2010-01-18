Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213Ab0ARUrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0ARUrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197Ab0ARUrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:47:09 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57703 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0ARUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:47:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j3I3mP+17pZSM06Avc0/89suFr9Jd8n/BHtMCGUbaBHmrxrelZoAgDZclqxate9IHh
         xZSii33/lTACyB40FgAXiZscuqWzQJiK5+ojbjqzg2qgaZwthJrJq1Lq4aM0QC+OWqt6
         fe336HTN47xmUSF6LeoZb2HC3NAXvHRoE+CSA=
Date: Mon, 18 Jan 2010 21:46:58 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100118204658.GC3157@del.dom.local>
References: <4B4E2F89.2050606@majjas.com>
 <20100113210908.GA3065@del.dom.local>
 <4B4E3834.3000609@majjas.com>
 <4B533A46.9050600@majjas.com>
 <20100117221746.GA3161@del.dom.local>
 <4B53906B.2020608@majjas.com>
 <20100117230531.GC3161@del.dom.local>
 <4B539A0A.2000504@majjas.com>
 <20100118073018.GA6270@ff.dom.local>
 <4B548C6B.10607@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B548C6B.10607@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:29:31AM -0500, Michael Breuer wrote:
> Ok - up on the two patches, no DMAR. Some early observations:
> 
> 1. There's an early on MMAP oops (see below). This happens once, at
> the completion of the transition to runlevel 5 (I've seen it
> entering runlevel 3 as well). This does not recur when runlevels are
> subsequently changed. I do not see this when running with DMAR
> enabled.

OK, you mentioned this oops (actually a warning only) happened during
previous tests too.

> 
> 2. The dropped tx packet (DHCP) is a bit harder to recreate, but it
> still happens.

Btw, I guess you improved the test because you didn't mention it here,
even after my explicit question?:
http://permalink.gmane.org/gmane.linux.network/149171

> Interestingly, I initially saw no dropped packets
> with ping - but after I went the DCHP route and eventually
> reconnected, I could then cause dropped tx packets with ping. To
> clarify:
> 
> a) start throughput
> b) ping device - no packet loss - this was true for the entire test run.
> c) start throughput again
> d) ping - no loss.
> e) drop wifi on the device & restart - first attempt worked. Repeat
> attempt yielded the dropped DHCPOFFER packets. After about 6 tries,
> the device reconnected to wifi.
> f) ping again (after the reconnection) - packet loss rate about 80%.
> g) simultaneously ping the wifi router - no loss.
> h) After a while, packets are no longer dropped during ping. If I
> manage to cause the dhcp drop again, and then ping after the device
> finally reconnects, packet loss is significant for a while (maybe 30
> sec to a minute). Then things return to normal. Note that the packet
> loss continues even if the reported throughput drops to nil.
> i) I can't cause the initial packet loss at RX rates below about
> 30,000KBPS (as reported by nethogs).  At rates over 40 I can
> reproduce this on this set of patches & config about 60% of the
> time.

I forgot to mention, but did you try to check if these lost ping
packets are "being dropped somewhere after wireshark sees them and
before hitting the wire" like DHCPOFFER? Aren't there any sky2
warnings/resets while this happens?

Jarek P.
