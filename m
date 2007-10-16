Return-Path: <linux-kernel-owner+w=401wt.eu-S1765903AbXJPFrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765903AbXJPFrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760192AbXJPFrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:47:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39187 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760162AbXJPFrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:47:39 -0400
Message-ID: <47145075.1080003@garzik.org>
Date: Tue, 16 Oct 2007 01:47:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, shemminger@linux-foundation.org
Subject: Re: [patch] forcedeth: fix the NAPI poll function
References: <20071015112430.GA30006@elte.hu> <20071015.125731.79447899.davem@davemloft.net> <20071015220357.GA7174@elte.hu> <20071015220720.GA16101@elte.hu> <20071015223009.GA27425@elte.hu> <4713EC59.4010106@pobox.com> <20071016054236.GA27906@elte.hu>
In-Reply-To: <20071016054236.GA27906@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeff Garzik <jgarzik@pobox.com> wrote:
> 
>> Two comments:
>>
>> 1) we have a vague definition of "RX work processed."  Due to error 
>> conditions and goto's in that function, rx_processed_cnt may or may 
>> not equal the number of packets actually processed.
>>
>> 2) man I dislike these inline C statement combinations (ranting at 
>> original code style, not you).  I would much rather waste a few extra 
>> lines of source code and make the conditions obvious:
>>
>> 	while (... && (rx_processed_cnt < limit)) {
>> 		rx_processed_cnt++;
>>
>> 		...
>> 	}
>>
>> or even
>>
>> 	while (1) {
>> 		...
>> 		if (rx_processed_cnt == limit)
>> 			break;
>> 		rx_processed_cnt++;
>> 	}
>>
>> The compiler certainly doesn't care, and IMO it prevents bugs.
> 
> agreed. Do you have an uptodate patch/git-URI for the forcedeth rewrite 
> you did? I can throw it into the testbed.

Branch 'fe-lock' of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git

It works here locally, but at this very minute I am rewriting those 
changesets yet again :)

	Jeff



