Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZJ2OYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZJ2OYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 10:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZJ2OYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 10:24:17 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:43192 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbZJ2OYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 10:24:16 -0400
Message-ID: <4AE9A587.7050400@gmail.com>
Date: Thu, 29 Oct 2009 15:24:07 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andreas Petlund <apetlund@simula.no>
CC: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
References: <4AE72079.4030504@simula.no> <4AE7262B.1060703@gmail.com> <4AE83FE4.1050309@nets.rwth-aachen.de> <alpine.DEB.2.00.0910281618330.19761@wel-95.cs.helsinki.fi> <58396856-6D7E-4CE1-8D66-D1F11205B0D5@simula.no>
In-Reply-To: <58396856-6D7E-4CE1-8D66-D1F11205B0D5@simula.no>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 29 Oct 2009 15:24:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Petlund a écrit :

> 
> The removal of exponential backoff on a general basis has been
> investigated and discussed already, for instance here:
> http://ccr.sigcomm.org/online/?q=node/416
> Such steps are, however considered drastic, and I agree that caution
> must be made to thoroughly investigate the effects of such changes.
> The changes introduced by the proposed patches, however, are not default
> behaviour, but an option for applications that suffer from the
> thin-stream TCP increased retransmission latencies. They will, as such,
> not affect all streams. In addition, the changes will only be active for
> streams which are perpetually thin or in the early phase of expanding
> their cwnd. Also, experiments performed on congested bottlenecks with
> tail-drop queues show very little (if any at all) effect on goodput for
> the modified scenario compared to a scenario with unmodified TCP streams.
> 
> Graphs both for latency-results and fairness tests can be found here:
> http://folk.uio.no/apetlund/lktmp/
> 

There should be a limit to linear timeouts, to say ... no more than 6 retransmits
(eventually tunable), then switch to exponential backoff. Maybe your patch
already implement such heuristic ?

True link collapses do happen, it would be good if not all streams wakeup in the same
second and make recovery very slow.

Thats too easy to accept possibly dangerous features with the excuse of saying
"It wont be used very much", because you cannot predict the future.

