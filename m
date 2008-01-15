Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbYAOPJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbYAOPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYAOPJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:09:13 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:41902 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYAOPJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:09:11 -0500
Message-ID: <478CCC95.8030405@hp.com>
Date: Tue, 15 Jan 2008 10:09:09 -0500
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ray Lee <ray-lk@madrabbit.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <2c0942db0801112137k3f3f885ek212d5cbaecb7fea0@mail.gmail.com> <478B8473.6080506@nortel.com> <478B943C.7080009@cosmosbay.com> <478BB722.1020004@nortel.com> <478BB904.3060903@cosmosbay.com> <478BBFE3.9030707@nortel.com>
In-Reply-To: <478BBFE3.9030707@nortel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Eric Dumazet wrote:
>> Chris Friesen a écrit :
> 
>>> Based on the profiling information we're spending time in 
>>> sctp_endpoint_lookup_assoc() which doesn't actually use hashes, so I 
>>> can't see how the hash would be related.  I'm pretty new to SCTP 
>>> though, so I may be missing something.
>>
>> Well, it does use hashes :)
>>
>>        hash = sctp_assoc_hashfn(ep->base.bind_addr.port, rport);
>>        head = &sctp_assoc_hashtable[hash];
>>        read_lock(&head->lock);
>>        sctp_for_each_hentry(epb, node, &head->chain) {
>>            /* maybe your machine is traversing here a *really* long 
>> chain */
>>            }
> 
> 
> The latest released kernel doesn't have this code, it was only added in 
> November.  The SCTP maintainer just pointed me to the patch, and made 
> some other suggestions as well.
> 

Yes,  the hash code only got added to 2.6.24.  Before that, it was
a linear list traversal which sucked.

I need to take a look at the locking to see if we can further reduce
the time that bottom half is disabled.

-vlad
