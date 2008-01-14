Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYANUDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYANUDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 15:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYANUDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 15:03:33 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:35070 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbYANUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 15:03:32 -0500
Message-ID: <478BBFE3.9030707@nortel.com>
Date: Mon, 14 Jan 2008 14:02:43 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ray Lee <ray-lk@madrabbit.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: questions on NAPI processing latency and dropped network packets
References: <478654C3.60806@nortel.com> <2c0942db0801112137k3f3f885ek212d5cbaecb7fea0@mail.gmail.com> <478B8473.6080506@nortel.com> <478B943C.7080009@cosmosbay.com> <478BB722.1020004@nortel.com> <478BB904.3060903@cosmosbay.com>
In-Reply-To: <478BB904.3060903@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jan 2008 20:02:46.0944 (UTC) FILETIME=[6EAF4200:01C856E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Chris Friesen a écrit :

>> Based on the profiling information we're spending time in 
>> sctp_endpoint_lookup_assoc() which doesn't actually use hashes, so I 
>> can't see how the hash would be related.  I'm pretty new to SCTP 
>> though, so I may be missing something.
> 
> Well, it does use hashes :)
> 
>        hash = sctp_assoc_hashfn(ep->base.bind_addr.port, rport);
>        head = &sctp_assoc_hashtable[hash];
>        read_lock(&head->lock);
>        sctp_for_each_hentry(epb, node, &head->chain) {
>            /* maybe your machine is traversing here a *really* long 
> chain */
>            }


The latest released kernel doesn't have this code, it was only added in 
November.  The SCTP maintainer just pointed me to the patch, and made 
some other suggestions as well.

Chris
