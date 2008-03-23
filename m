Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYCWGix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYCWGix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 02:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYCWGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 02:38:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:6166 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbYCWGiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 02:38:46 -0400
Message-ID: <47E5FAF2.2060508@colorfullife.com>
Date: Sun, 23 Mar 2008 07:38:42 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net> <47E3B924.3000304@colorfullife.com> <20080321141339.GB9618@linux.vnet.ibm.com> <47E3DD8C.4000904@colorfullife.com> <1206164608.3659.11.camel@marge.simson.net> <47E4DB06.3020003@colorfullife.com> <1206186832.4545.1.camel@marge.simson.net> <47E51637.8060102@colorfullife.com> <1206214504.4538.8.camel@marge.simson.net>
In-Reply-To: <1206214504.4538.8.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2008-03-22 at 15:22 +0100, Manfred Spraul wrote:
>   
>> Mike Galbraith wrote:
>>     
>>> Total: 4691827                                Total: 3942000
>>>   
>>>       
>> Thanks. Unfortunately the test was buggy, it bound the tasks to the 
>> wrong cpu :-(
>> Could you run it again? Actually 1 cpu and 4 cpus are probably enough.
>>     
>
> Sure.  (ran as before, hopefully no transcription errors)
>
>   
Thanks:
sysv sem:
- 2.6.22 had almost linear scaling (up to 4 cores).
- 2.6.24.3 scales to 2 cpus, then it collapses. with 4 cores, it's 75% 
slower than 2.6.22.

sysv msg:
- neither 2.6.22 nor 2.6.24 scale very good. That's more or less 
expected, the message queue code contains a few global statistic 
counters (msg_hdrs, msg_bytes).

The cleanup of sysv is nice, but IMHO sysv sem should remain scalable - 
and a gloal semaphore with IDR can't be as scalable as the RCU protected 
array that was used before.

--
    Manfred
