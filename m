Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347Ab0ARW0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0ARW0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 17:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071Ab0ARW0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 17:26:38 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:56783 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0ARW0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 17:26:37 -0500
Date: Mon, 18 Jan 2010 17:25:43 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
In-reply-to: <20100118220814.GG3157@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-id: <4B54DFE7.4060802@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20100117221746.GA3161@del.dom.local> <4B53906B.2020608@majjas.com>
 <20100117230531.GC3161@del.dom.local> <4B539A0A.2000504@majjas.com>
 <20100118073018.GA6270@ff.dom.local> <4B548C6B.10607@majjas.com>
 <20100118204658.GC3157@del.dom.local> <4B54CB0D.5070604@majjas.com>
 <20100118212516.GE3157@del.dom.local> <4B54D50C.90608@majjas.com>
 <20100118220814.GG3157@del.dom.local>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/2010 5:08 PM, Jarek Poplawski wrote:
> On Mon, Jan 18, 2010 at 04:39:24PM -0500, Michael Breuer wrote:
>    
>> Some output from tc -s qdisc:
>>      
> ...
>    
>> After the conclusion of the test:
>> qdisc pfifo_fast 0: dev eth0 root refcnt 2 bands 3 priomap  1 2 2 2
>> 1 2 0 0 1 1 1 1 1 1 1 1
>>   Sent 244900497 bytes 3416350 pkt (dropped 0, overlimits 0 requeues 0)
>>   rate 0bit 0pps backlog 0b 0p requeues 0
>> qdisc pfifo_fast 0: dev eth1 root refcnt 2 bands 3 priomap  1 2 2 2
>> 1 2 0 0 1 1 1 1 1 1 1 1
>>   Sent 564380 bytes 4708 pkt (dropped 0, overlimits 0 requeues 0)
>>   rate 0bit 0pps backlog 0b 0p requeues 0
>>      
> Great!
>
>    
>>
>> During the test, 8.9GB received; 232.9MB sent).
>>
>> I also connected a second device through the wifi router. I was able
>> to ping that device w/o loss while DHCP packets were being dropped
>> to the other connected device.
>>      
> Could you remind us if the problem is always with this first device?
> Btw, I wonder if you could test it skipping the (HP?) switch?
>
> Jarek P.
>    
No - can be any device connected via the wifi router - wired or wireless.
