Return-Path: <linux-kernel-owner+w=401wt.eu-S1751411AbXCHDOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411AbXCHDOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 22:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXCHDOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 22:14:42 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45732 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbXCHDOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 22:14:40 -0500
Message-ID: <45EF7EB7.8040806@linux-foundation.org>
Date: Wed, 07 Mar 2007 19:10:47 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
Organization: Linux Foundation
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: w@1wt.eu, rkuhn@e18.physik.tu-muenchen.de, andi@firstfloor.org,
       dada1@cosmosbay.com, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp_cubic: use 32 bit math
References: <20070306145842.7d7fea84@freekitty>	<20070307060838.GI943@1wt.eu>	<20070307170731.2b4397e3@freekitty> <20070307.185539.48527371.davem@davemloft.net>
In-Reply-To: <20070307.185539.48527371.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Stephen Hemminger <shemminger@linux-foundation.org>
> Date: Wed, 7 Mar 2007 17:07:31 -0800
>
>   
>> The basic calculation has to be done in 32 bits to avoid
>> doing 64 bit divide by 3. The value x is only 22bits max
>> so only need full 64 bits only for x^2.
>>
>> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
>>     
>
> Applied, thanks Stephen.
>
> What about Willy Tarreau's supposedly even faster variant?
> Or does this incorporate that set of improvements?
>   
That's what this is:
    x = (2 * x + (uint32_t)div64_64(a, (uint64_t)x*(uint64_t)x)) / 3;

