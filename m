Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0BAJBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 04:01:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab0BAJBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 04:01:14 -0500
Message-ID: <4B669921.6090808@redhat.com>
Date: Mon, 01 Feb 2010 17:04:33 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch] net: export TCP send buffer size via netlink
References: <20100201080256.4084.30962.sendpatchset@localhost.localdomain> <1265014309.2848.7.camel@edumazet-laptop>
In-Reply-To: <1265014309.2848.7.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le lundi 01 février 2010 à 02:59 -0500, Amerigo Wang a écrit :
>> Currently, we can only get TCP send buffer size by
>> getsockopt (SO_SNDBUF or TCP_INFO), this is not enough
>> for the tools like netstat or ss to read.
>>
>> Show TCP send buffer size via netlink NETLINK_INET_DIAG.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: David Miller <davem@davemloft.net>
>>
>> ---
>> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
>> index 7fee8a4..46768de 100644
>> --- a/include/linux/tcp.h
>> +++ b/include/linux/tcp.h
>> @@ -136,6 +136,7 @@ struct tcp_info {
>>  	__u32	tcpi_ato;
>>  	__u32	tcpi_snd_mss;
>>  	__u32	tcpi_rcv_mss;
>> +	__u32	tcpi_sndbuf;
>>  
>>  	__u32	tcpi_unacked;
>>  	__u32	tcpi_sacked;
> 
> You cannot change tcp_info like this, this structure is used by some
> programs, and they are going to break badly.
> 

Oh, right, I forgot the ABI compatibility...
I will append it to this structure.

Thanks!

