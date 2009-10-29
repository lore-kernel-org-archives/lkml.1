Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZJ2Qcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZJ2Qcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZJ2Qck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:32:40 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:54271 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbZJ2Qck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:32:40 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.44,646,1249250400";   d="scan'208";a="31720054"
Message-id: <4AE9C396.3040705@nets.rwth-aachen.de>
Date: Thu, 29 Oct 2009 17:32:22 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
To: Andreas Petlund <apetlund@simula.no>
Cc: William Allen Simpson <william.allen.simpson@gmail.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       "ilpo.jarvinen@helsinki.fi" <ilpo.jarvinen@helsinki.fi>,
       "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] net: TCP thin-stream detection
References: <4AE72075.4070702@simula.no> <4AE7B5D6.8070001@gmail.com>
 <38EB8C31-A96A-4C5C-88D8-8F6BF0E9225F@simula.no>
In-reply-to: <38EB8C31-A96A-4C5C-88D8-8F6BF0E9225F@simula.no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Petlund schrieb:
> Den 28. okt. 2009 kl. 04.09 skrev William Allen Simpson:
> 
>> Andreas Petlund wrote:
>>> +/* Determines whether this is a thin stream (which may suffer from
>>> + * increased latency). Used to trigger latency-reducing mechanisms.
>>> + */
>>> +static inline unsigned int tcp_stream_is_thin(const struct  
>>> tcp_sock *tp)
>>> +{
>>> +	return tp->packets_out < 4;
>>> +}
>>> +
>> This bothers me a bit.  Having just looked at your Linux presentation,
>> and not (yet) read your papers, it seems much of your justification  
>> was
>> with 1 packet per RTT.  Here, you seem to be concentrating on 4,  
>> probably
>> because many implementations quickly ramp up to 4.
>>
> 
> The limit of 4 packets in flight is based on the fact that less than 4  
> packets in flight makes fast retransmissions impossible, thus limiting  
> the retransmit options to timeout-retransmissions. The criterion is  

There is Limited Transmit! So this is generally not true.

> therefore as conservative as possible while still serving its purpose.  
> If further losses occur, the exponential backoff will increase latency  
> further. The concept of using this limit is also discussed in the  
> Internet draft for Early Retransmit by Allman et al.:
> http://www.icir.org/mallman/papers/draft-ietf-tcpm-early-rexmt-01.txt

This ID is covering exactly the cases which Limited Transmit does not
cover and works "automagically" without help of application. So why not
just implement this ID?

Best regards,
Arnd
