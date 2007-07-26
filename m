Return-Path: <linux-kernel-owner+w=401wt.eu-S936989AbXGZUuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936989AbXGZUuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934341AbXGZUuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:50:23 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:60438 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765594AbXGZUuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:50:23 -0400
Message-ID: <46A908E4.7080502@hp.com>
Date: Thu, 26 Jul 2007 16:49:40 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Dave Johnson <djohnson+linux-kernel@sw.starentnetworks.com>
Cc: lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Srinivas Akkipeddi <sakkiped@starentnetworks.com>
Subject: Re: [PATCH] SCTP: IPv4 mapped addr not returned in SCTPv6 accept()
References: <18087.57737.908842.337891@zeus.sw.starentnetworks.com>	<46A8E027.10802@hp.com>	<18088.61269.5608.925496@zeus.sw.starentnetworks.com>	<46A8F926.1070606@hp.com> <18089.1986.267726.233112@zeus.sw.starentnetworks.com>
In-Reply-To: <18089.1986.267726.233112@zeus.sw.starentnetworks.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Johnson wrote:
> Vlad Yasevich writes:
>> Ok.  First, this is a different bug, so I would prefer a separate patch.
>> Also, I see the problem and it's ugly, but this solution is not really correct,
>> both conceptually and code wise.
>>
>> Conceptually, the v4 code should never worry about V4-mapped addresses and shouldn't
>> muck with them.  They are IPv6 addresses and there should be a clean separation.
>>
>> Code wise, the code in the __sctp_connect() is terrible.
>>
>> Does the attached patch work for you in this case.
> 
> yes, with the v4mapped in ipv6.c and your patch, connect and accept
> both work with v4 mapped addresses.
> 
> Note instead of:
> 
>> +	af = sctp_get_af_specific(sa_addr->sa.sa_family);
>> +	af->to_sk_daddr(sa_addr, sk);
> 
> you should have:
> 
>> +	af = sctp_get_af_specific(sa_addr->sa_family);
>> +	af->to_sk_daddr((union sctp_addr *)sa_addr, sk);
> 
> 

Feel free to clean it up and submit both patches.

-vlad
