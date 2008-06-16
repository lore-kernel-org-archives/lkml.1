Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbYFPSK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbYFPSK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 14:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbYFPSKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 14:10:09 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:48267 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYFPSKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 14:10:07 -0400
Date: Mon, 16 Jun 2008 11:09:34 -0700
From: Matheos Worku <Matheos.Worku@Sun.COM>
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
In-reply-to: <20080530.000009.02995266.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: jesper@krogh.cc, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Message-id: <4856AC5E.1010206@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=us-ascii
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <483CB301.40007@sun.com>
 <20080528.223415.193732490.davem@davemloft.net> <483F46E5.9030707@sun.com>
 <20080530.000009.02995266.davem@davemloft.net>
User-Agent: Mozilla Thunderbird 1.0.7-1.4.1 (X11/20050929)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

>From: Matheos Worku <Matheos.Worku@Sun.COM>
>Date: Thu, 29 May 2008 17:14:29 -0700
>
>  
>
>>Actually what I am suggesting was a workaround for the lack of "TX Ring 
>>Empty" interrupt by not relying on the TX interrupt at all.
>>    
>>
>
>Ahh I see.
>
>Some of the things I talked about in my presentation here in
>Berlin at LinuxTAG yesterday can help mitigate the effects.
>Most of it revolves around batching, and allowing the driver
>to manage the backlog of packets directly when the TX queue
>fills up.
>
>In such a case we could batch the TX queue refill, know how many more
>TX packets we will queue up to the chip right now, and therefore know
>that we can safely set periodic MARK bits and only need to force set
>the MARK bit at the very end.
>
>  
>
>>As for the TX hang, I will try to reproduce the problem and look at
>>the registers for the clue.
>>    
>>
Have been trying but not able to reproduce the timeout. I am using NFS 
V3 with TCP. Are you using UDP by any chance?

Regards
Matheos

>
>Thanks a lot.
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>  
>

