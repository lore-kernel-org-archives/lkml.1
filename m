Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbZJ2Pu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbZJ2Pu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbZJ2Pu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 11:50:26 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:34798 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbZJ2Pu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 11:50:26 -0400
Message-ID: <4AE9B9BA.7020207@gmail.com>
Date: Thu, 29 Oct 2009 16:50:18 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: apetlund@simula.no
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
References: <69812160e5682c9fb4acba05bc082664.squirrel@webmail.uio.no>
In-Reply-To: <69812160e5682c9fb4acba05bc082664.squirrel@webmail.uio.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 29 Oct 2009 16:50:19 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

apetlund@simula.no a écrit :
>> Andreas Petlund a écrit :

>> There should be a limit to linear timeouts, to say ... no more than 6
> retransmits
>> (eventually tunable), then switch to exponential backoff. Maybe your
> patch
>> already implement such heuristic ?
>>
> 
> The limitation you suggest to the linear timeouts makes very good sense.
> Our experiments performed on the Internet indicate that it is extremely
> rare that more than 6 retransmissions are needed to recover. It is not
> included in the current patch, so I will include this in the next
> iteration.
> 
>> True link collapses do happen, it would be good if not all streams
> wakeup
>> in the same
>> second and make recovery very slow.
>>
> 
> Each stream will have its own schedule for wakeup, so such events will
> still be subject to coincidence. The timer granularity of the TCP wakeup
> timer will also influence how many streams will wake at the same time. The
> experiments we have performed on severely congested bottlenecks (link
> above) indicate that the modifications will not create a large negative
> effect. In fact, when goodput is drastically reduced due to severe
> overload, regular TCP and the LT and dupACK modifications seem to perform
> nearly identically. Other scenarios may exist where different effects can
> be observed, and I am open to suggestions for further testing.
> 
>> Thats too easy to accept possibly dangerous features with the excuse of
> saying
>> "It wont be used very much", because you cannot predict the future.
> 
> I agree that it is no argument to say that it won't be used much; indeed,
> my hope is that it will be used much. However, our experiments indicate no
> negative effects while showing a large improvement on retransmission
> latency for the scenario in question. I therefore think that the option
> for such an improvement should be made available for time-dependent
> thin-stream applications.
> 

Thanks ! I must say I am very interested by these experiments, I am looking
forward your next iteration.

