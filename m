Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbZKEFgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbZKEFgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZKEFgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:36:52 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:60313 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZKEFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:36:51 -0500
Message-ID: <4AF26471.6010705@us.ibm.com>
Date: Wed, 04 Nov 2009 21:36:49 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
References: <20091105112303.208A.A69D9226@jp.fujitsu.com> <4AF25FFB.5020700@us.ibm.com> <20091105141953.2090.A69D9226@jp.fujitsu.com>
In-Reply-To: <20091105141953.2090.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> KOSAKI Motohiro wrote:
>>
>>> John, I'd prefer to suggested another design.
>>> How about this?
>>>
>>> 1. remove pid argument from prctl
>>> 2. cancel pthread_setname_np()
>>> 3. instead, create pthread_attr_setname_np()
>>> 4. pthread_create() change own thread name by pthread_attr.
>>>
>>> It avoid many racy problem automatically.
>> Perhaps, but it also greatly reduces the flexibility of the 
>> implementation by restricting name changes to create time.
> 
> Hm.
> if your program really need to change another thread name, can you please tell us
> why it is necessary and when it is used?
> 

I think John's previous mails covered that pretty well. As for doing the 
name change at create time, or sometime later, it just seems to me that 
the flexibility of doing so later is worth having. While I know we don't 
have to follow other systems implementations, in this case 
pthread_setname_np() seems a reasonable model to follow to me.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
