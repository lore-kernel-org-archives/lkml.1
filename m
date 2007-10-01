Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbXJAIfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbXJAIfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXJAIfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:35:09 -0400
Received: from smtp23.orange.fr ([80.12.242.50]:19039 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbXJAIfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:35:08 -0400
X-ME-UUID: 20071001083506468.7278C1C00090@mwinf2303.orange.fr
Message-ID: <4700B136.8050109@cosmosbay.com>
Date: Mon, 01 Oct 2007 10:35:02 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.7 (Windows/20060909)
MIME-Version: 1.0
Cc: Denys <nuclearcat@nuclearcat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
References: <200709301425.37564.nickpiggin@yahoo.com.au> <20070930223503.M8966@nuclearcat.com> <47008CB0.7010808@cosmosbay.com> <20071001.001259.28812610.davem@davemloft.net> <20071001080339.M21850@nuclearcat.com> <4700ADB7.7050102@cosmosbay.com>
In-Reply-To: <4700ADB7.7050102@cosmosbay.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet a écrit :
> Denys a écrit :
>> Well, i can play a bit more on "live" servers. I have now hot-swap 
>> server with
>> full gentoo,  where i can rebuild any kernel you want, with any 
>> applied patch.
>> But it looks more like not overhead, load becoming high too "spiky", 
>> and it is
>> not just permantenly higher. Also it is not normal that all system 
>> becoming
>> unresposive (for example ping 127.0.0.1 becoming 300ms for period, 
>> when usage
>> softirq jumps to 100%).
>>
>>   
> Could you try a pristine 2.6.22.9 and some patch in 
> secure_tcp_sequence_number() like :
>
> --- drivers/char/random.c.orig 2007-10-01 10:18:42.000000000 +0200
> +++ drivers/char/random.c 2007-10-01 10:19:58.000000000 +0200
> @@ -1554,7 +1554,7 @@
> * That's funny, Linux has one built in! Use it!
> * (Networks are faster now - should this be increased?)
> */
> - seq += ktime_get_real().tv64;
> + seq += ktime_get_real().tv64 / 1000;
> #if 0
> printk("init_seq(%lx, %lx, %d, %d) = %d\n",
> saddr, daddr, sport, dport, seq);
On 32 bits machine, replace the divide by a shift  to avoid a linker 
error (undefined reference to `__divdi3'):  

seq += ktime_get_real().tv64 >> 10;





