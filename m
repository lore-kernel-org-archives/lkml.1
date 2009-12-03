Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZLCREZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZLCREZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZLCREY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:04:24 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:33746 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbZLCREX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:04:23 -0500
Message-ID: <4B17EF8E.60704@gmail.com>
Date: Thu, 03 Dec 2009 18:04:14 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: netdev@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: seeing strange values for tcp sk_rmem_alloc
References: <4B15416A.2060202@nortel.com> <4B154B29.1030807@cosmosbay.com> <4B155252.1040604@nortel.com> <4B1557CC.4060503@gmail.com> <4B17ED8D.7050409@nortel.com>
In-Reply-To: <4B17ED8D.7050409@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 03 Dec 2009 18:04:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen a écrit :
> On 12/01/2009 11:52 AM, Eric Dumazet wrote:
> 
>> But be careful of sender tcp stack : It might be delayed a bit,
>> because it waits for receiver to open its window (slow start)
>>
>> You probably need something like
>>
>> while (1) {
>> 	send(fd1, buffer, 2Kbytes);
>> 	sleep(2); // let tcp stack flush its write buffers
>> 	display_sk_rmem_alloc(fd2);
>> }
> 
> Ah, that makes a difference.  But the results (see below) still look
> odd.  For this test, /proc/sys/net/core/rmem_default is 118784.  For
> some reason sk_rmem_alloc gets bumped by 16KB when I only send 2KB of
> data, and it drops back down again every 6 packets.
> 
> Chris

Might be because you use loopback device ? ;)

ifconfig lo | grep MTU
          UP LOOPBACK RUNNING  MTU:16436  Metric:1

After a while (when hitting rcvbuf limit), tcp stack performs skb collapses, to reduce ram usage.

