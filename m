Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZKLTJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZKLTJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbZKLTJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:09:36 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36450 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZKLTJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:09:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WpLwyaAv0yowoI9CMobTv7B0hUjRDiQD+WQNhFihInz+tkcVRyAXOvVjHvLp34VnKq
         YuCsSRgcTtawpbiMmU6AS07RTK7pc5wS8nKgwdvBvJlrX4Yeabfn/Txf+MH/FFlWEfC7
         42F/Lu7HPuqCAxkc5BlFF69uQzy+8b42VEDjM=
Message-ID: <4AFC5C58.9030207@gmail.com>
Date: Thu, 12 Nov 2009 20:04:56 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Caleb Cushing <xenoterracide@gmail.com>
CC: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: large packet loss take2 2.6.31.x
References: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>	 <20091112113836.GA7963@ff.dom.local> <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
In-Reply-To: <81bfc67a0911120546g26627ac5q5860d85f446b29bb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caleb Cushing wrote, On 11/12/2009 02:46 PM:

>> On 11-11-2009 22:47, Andi Kleen wrote:
>> ...
>>> It might be also useful if you could describe what kind
>>> of network devices you use and how you determine
>>> the packet loss.
>> Btw, you didn't send the stats you compared, and your wireshark dump
>> doesn't show anything wrong either.
>>
>> Jarek P.
>>
> 
> I didn't see that sorry. I wasn't sure if the dump would or not (I'm
> not a networking expert, just know more than the average joe).
> 
> from dmesg (networking device)
> 
> e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
> 
> from lspci
> 
> 00:19.0 Ethernet controller: Intel Corporation 82562V-2 10/100 Network
> Connection (rev 02)

So I assume it's your only network device on this box and according
to these reports it's 192.168.1.3 with 192.168.1.1 as the gateway,
and your only change is kernel on this 192.168.1.3 box, right?

> the attached png's show mtr with bad being when I have the problem.
> for those not familiar mtr sends an icmp packet to each hop in 1
> second then loops. when I'm having this kind of packet loss (and
> sometimes it's higher) all services including dhcp, dns, and http (web
> browsing) get flaky, or don't work at all (I really can't browse the
> web).

Since the loss is seen on the first hop already, it seems it should be
enough to query 192.168.1.1 only - did you try this? If so, does this
happen from the beginning of the test or after many loops? Could you
try to repeat this wireshark dump with more data than before (but just
to be sure there are a few unanswered pings). If possible it would be
nice to have wireshark or tcpdump data from 192.168.1.1 too, while
pinged from 192.168.1.3. Please, send it gzipped to bugzilla only plus
ifconfig eth0 before and after the test (and let us know here).

Btw, mtr has text reporting too (--report). Larger things send to
bugzilla only.

Thanks,
Jarek P.
