Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab0CCOFN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:05:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54323
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335Ab0CCOFK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:05:10 -0500
Date: Wed, 03 Mar 2010 06:05:29 -0800 (PST)
Message-Id: <20100303.060529.195713861.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: efault@gmx.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu
Subject: Re: [rfc/rft][patch] should use scheduler sync hint in
 tcp_prequeue()?
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267529273.2964.111.camel@edumazet-laptop>
References: <1267522901.25906.101.camel@marge.simson.net>
	<1267529273.2964.111.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 02 Mar 2010 12:27:53 +0100

> Le mardi 02 mars 2010 à 10:41 +0100, Mike Galbraith a écrit :
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 34f5cc2..ba3fc64 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -939,7 +939,7 @@ static inline int tcp_prequeue(struct sock *sk, struct sk_buff *skb)
>>  
>>  		tp->ucopy.memory = 0;
>>  	} else if (skb_queue_len(&tp->ucopy.prequeue) == 1) {
>> -		wake_up_interruptible_poll(sk->sk_sleep,
>> +		wake_up_interruptible_sync_poll(sk->sk_sleep,
>>  					   POLLIN | POLLRDNORM | POLLRDBAND);
>>  		if (!inet_csk_ack_scheduled(sk))
>>  			inet_csk_reset_xmit_timer(sk, ICSK_TIME_DACK,
>> 
 ...
> Ingo probably can answer to this question, since he changed
> sock_def_readable() (and others) in commit 6f3d09291b498299
> I suspect he missed tcp_prequeue() case, maybe not...

It definitely looks like an oversight to me and we should add
be using wake_up_interruptible_sync_poll() in tcp_prequeue()
as above.

Ingo?
