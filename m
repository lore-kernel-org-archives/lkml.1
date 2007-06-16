Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbXFPOIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbXFPOIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 10:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXFPOIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 10:08:12 -0400
Received: from comtv.ru ([217.10.32.17]:53214 "EHLO comtv.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbXFPOIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 10:08:11 -0400
X-UCL: actv
Date: Sat, 16 Jun 2007 18:07:41 +0400 (MSD)
From: malc <av1474@comtv.ru>
X-X-Sender: malc@linmac.oyster.ru
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] sched: accurate user accounting
In-Reply-To: <4673E3D9.2020300@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0706161732040.2619@linmac.oyster.ru>
References: <200703251159.03616.kernel@kolivas.org>
 <Pine.LNX.4.64.0703252107590.31900@linmac.oyster.ru> <200703260901.54943.kernel@kolivas.org>
 <200703260957.34798.kernel@kolivas.org> <Pine.LNX.4.64.0703261439270.2621@linmac.oyster.ru>
 <20070328113743.GA5615@elte.hu> <Pine.LNX.4.64.0706142149020.2991@linmac.oyster.ru>
 <20070614204253.GA14076@elte.hu> <Pine.LNX.4.64.0706150052190.3404@linmac.oyster.ru>
 <20070614211828.GA21243@elte.hu> <Pine.LNX.4.64.0706150129430.3526@linmac.oyster.ru>
 <46720B19.5000006@linux.vnet.ibm.com> <Pine.LNX.4.64.0706151002530.2175@linmac.oyster.ru>
 <4673E3D9.2020300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Balbir Singh wrote:

> malc wrote:
>> On Fri, 15 Jun 2007, Balbir Singh wrote:
>>
>>> malc wrote:
>>>> On Thu, 14 Jun 2007, Ingo Molnar wrote:
>>>>
>>
>> [..snip..]
>>
>>>>
>>>> Now integral load matches the one obtained via the "accurate" method.
>>>> However the report for individual cores are of by around 20% percent.
>>>>
>>>
>>> I think I missed some of the context, is the accounting of individual
>>> tasks
>>> or cpustat values off by 20%? I'll try and reproduce this problem.
>>
>> Neither actually, the individual core idle times reported via `/proc/stat'
>> are off by 20 percent, one over estimates and the other under estimates
>> and the sum is right on the mark.
>>
>
> Interesting, the idle time accounting (done from account_system_time())
> has not changed. Has your .config changed? Could you please send
> it across. I've downloaded apc and I am trying to reproduce your problem.

http://www.boblycat.org/~malc/apc/cfs/ has config for 2.6.21 an the 
diff against 2.6.21.4-cfs-v16.

I updated hog (can be found in the above directory) to call setitimer
with a bit saner values (apprantly tickless has profound effect on
itimers interface). While fooling around with this version of hog
on 2.6.21.4-cfs-v16 i stumbled upon rather strange behavior (the
screenshot is also at the address above, note that kernel was booted
with maxcpus=1)

[..snip..]

-- 
vale
