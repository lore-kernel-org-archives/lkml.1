Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbXJOWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbXJOWlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761143AbXJOWl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:41:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58636 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762846AbXJOWl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:41:27 -0400
Message-ID: <4713EC8A.5010607@garzik.org>
Date: Mon, 15 Oct 2007 18:41:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <4713EC59.4010106@pobox.com>
In-Reply-To: <4713EC59.4010106@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>> --- linux.orig/drivers/net/forcedeth.c
>> +++ linux/drivers/net/forcedeth.c
>> @@ -2274,7 +2274,7 @@ static int nv_rx_process(struct net_devi
>>  
>>      while((np->get_rx.orig != np->put_rx.orig) &&
>>            !((flags = le32_to_cpu(np->get_rx.orig->flaglen)) & 
>> NV_RX_AVAIL) &&
>> -        (rx_processed_cnt++ < limit)) {
>> +        (++rx_processed_cnt < limit)) {
>>  
>>          dprintk(KERN_DEBUG "%s: nv_rx_process: flags 0x%x.\n",
>>                      dev->name, flags);
>> @@ -2412,7 +2412,7 @@ static int nv_rx_process_optimized(struc
>>  
>>      while((np->get_rx.ex != np->put_rx.ex) &&
>>            !((flags = le32_to_cpu(np->get_rx.ex->flaglen)) & 
>> NV_RX2_AVAIL) &&
>> -          (rx_processed_cnt++ < limit)) {
>> +          (++rx_processed_cnt < limit)) {


Though it wasn't clear, that's an ACK

I'll push the patch if nobody else beats me to it.

