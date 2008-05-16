Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYEPGMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYEPGMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 02:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbYEPGMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 02:12:23 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:24537 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbYEPGMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 02:12:22 -0400
X-IronPort-CTest: t
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkEBAK/ALEjLGl9BiGdsb2JhbACLWIZQAQEBDyCcAw
X-IronPort-AV: E=Sophos;i="4.27,495,1204464600"; 
   d="scan'208";a="113365919"
Message-ID: <05be01c8b71b$cbb0c9e0$f903a33a@SABINE>
From: "Kingsley Foreman" <kingsley@internode.com.au>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Cc: "Patrick McHardy" <kaber@trash.net>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net> <20080515182504.GB2936@ami.dom.local> <482C81CC.7000305@trash.net> <20080515184646.GC2936@ami.dom.local> <1A70765F4B30462EB21A3B3A8A442633@uglypunk> <20080516054959.GA3918@ff.dom.local>
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Date: Fri, 16 May 2008 15:42:18 +0930
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok after some playing a bit if i use

tc qdisc change dev bond0 parent 1: pfifo limit 30

the dropped packets go away, im not sure if that is considered normal or 
not, however any number under 30 gives me issues.

Kingsley

----- Original Message ----- 
From: "Jarek Poplawski" <jarkao2@gmail.com>
To: "Kingsley Foreman" <kingsley@internode.com.au>
Cc: "Patrick McHardy" <kaber@trash.net>; "Eric Dumazet" 
<dada1@cosmosbay.com>; "Andrew Morton" <akpm@linux-foundation.org>; 
<linux-kernel@vger.kernel.org>; <netdev@vger.kernel.org>
Sent: Friday, May 16, 2008 3:19 PM
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface


> On Fri, May 16, 2008 at 06:57:23AM +0930, Kingsley Foreman wrote:
> ...
>> running
>>
>> tc qdisc add dev bond0 root pfifo limit 1000
>>
>> or
>>
>> tc qdisc add dev bond0 root handle 1: cbq bandwidth 2000Mbit avpkt 1000
>> cell 0
>> tc qdisc add dev bond0 parent 1: pfifo limit 1000
>>
>>
>> doesn't appear to be dropping packets.
>>
>
> Great! So it looks like there is no error here unless there are needed
> significantly bigger queues to stop this dropping compared to 2.6.22.
> You could try to lower this limit now to something like 10 to find when
> drops start to appear. Why 2.6.22 doesn't need this at all is a mistery
> anyway (old scheduler?), and it would really need some work (like git
> bisection) to find the reason for more than 5 or 10 packet difference.
>
> Thanks,
> Jarek P.
> 

