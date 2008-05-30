Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYE3AOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYE3AOl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 20:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYE3AOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 20:14:31 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:60172 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYE3AO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 20:14:29 -0400
Date: Thu, 29 May 2008 17:14:29 -0700
From: Matheos Worku <Matheos.Worku@Sun.COM>
Subject: Re: NIU - Sun Neptune 10g - Transmit timed out reset (2.6.24)
In-reply-to: <20080528.223415.193732490.davem@davemloft.net>
To: David Miller <davem@davemloft.net>
Cc: jesper@krogh.cc, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Message-id: <483F46E5.9030707@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Accept-Language: en-us, en
References: <20080526.151540.191673092.davem@davemloft.net>
 <483BA80C.4020502@krogh.cc> <483CB301.40007@sun.com>
 <20080528.223415.193732490.davem@davemloft.net>
User-Agent: Mozilla Thunderbird 1.0.7-1.4.1 (X11/20050929)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

>From: Matheos Worku <Matheos.Worku@Sun.COM>
>Date: Tue, 27 May 2008 18:18:57 -0700
>
>  
>
>>Considering that fixing the HW would take considerable time, I was 
>>wondering if the scheme we use in the nxge driver could be considered as 
>>a workaround. Since the niu driver is already doing skb_orphan as a work 
>>around, what if  already transmitted TX buffers are  reclaimed 
>>periodically, within dev->hard_start_xmit() ?  Then TX_DESC_MARK would 
>>be set if/when available TX descriptor count falls below some watermark. 
>>Disable device TX queue about the time  TX_DESC_MARK is set and enable 
>>it within TX interrupt.
>>    
>>
>
>Since my hack patch didn't fix his problem at all, are you suggesting
>that we end up not fielding TX mark interrupts even though mark is set
>in all the TX descriptors and this is what hangs the chip?
>
>I find that very unlikely, especially because with my test patch every
>single TX descriptor will have the mark bit set and therefore we'd
>have to not receive all of those TX mark interrupts in order for the
>TX unit to hang like that.
>
>Something else must be going wrong.
>  
>
Dave,
Actually what I am suggesting was a workaround for the lack of "TX Ring 
Empty" interrupt by not relying on the TX interrupt at all.  As for the 
TX hang, I will try to reproduce the problem and look at the registers 
for the clue.

Regards
Matheos

