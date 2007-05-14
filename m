Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbXENOKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbXENOKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 10:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXENOK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 10:10:27 -0400
Received: from mail.tmr.com ([64.65.253.246]:36131 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753729AbXENOK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 10:10:27 -0400
Message-ID: <46486DEC.1080506@tmr.com>
Date: Mon, 14 May 2007 10:10:52 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] "volatile considered harmful" document
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no> <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca> <m33b208z5f.fsf@maximus.localdomain> <46479E95.6050507@tmr.com> <20070513235341.GA4270@havoc.gtf.org>
In-Reply-To: <20070513235341.GA4270@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> On Sun, May 13, 2007 at 07:26:13PM -0400, Bill Davidsen wrote:
>   
>> Krzysztof Halasa wrote:
>>     
>>> Robert Hancock <hancockr@shaw.ca> writes:
>>>       
>>>> You don't need volatile in that case, rmb() can be used.
>>>>         
>
>   
>>> rmb() invalidates all compiler assumptions, it can be much slower.
>>>       
>
> It does not invalidate /all/ assumptions.
>
>
>   
>> Yes, why would you use rmb() when a read of a volatile generates optimal 
>> code?
>>     
>
> Read of a volatile is guaranteed to generate the least optimal code.
> That's what volatile does, guarantee no optimization of that particular
> access.
>   
By optimal you seem to mean "generate fewer CPU cycles by risking use of 
an obsolete value," while by the same term I mean read the correct and 
current value from the memory location without the overhead of locks. If 
your logic doesn't require the correct value, why read it at all? And if 
it does, how fewer cycles and cache impact can anything have than a 
single register load from memory?

Locks are useful when the value will be changed by a thread, or when the 
value must not be changed briefly. That's not always the case.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

