Return-Path: <linux-kernel-owner+w=401wt.eu-S1752731Ab0AaERu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0AaERu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 23:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450Ab0AaERt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 23:17:49 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:63507 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab0AaERs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 23:17:48 -0500
Date: Sat, 30 Jan 2010 23:17:41 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [PATCH] sky2:  receive dma mapping error handling
In-reply-to: <20100131003449.GA11935@del.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>, Don Fry <pcnet32@verizon.net>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Matt Carlson <mcarlson@broadcom.com>
Message-id: <4B650465.7010503@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B61ADF1.7060705@majjas.com> <4B61BEA4.1030905@majjas.com>
 <20100128090835.0d93e53a@nehalam> <4B61DB79.4080703@majjas.com>
 <20100128223447.GC3109@del.dom.local> <4B621316.8070308@majjas.com>
 <20100128225621.GD3109@del.dom.local> <4B6216B9.1010802@majjas.com>
 <20100128153643.0fca3c51@nehalam> <4B645EF4.4050701@majjas.com>
 <20100131003449.GA11935@del.dom.local>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7)
 Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2010 07:34 PM, Jarek Poplawski wrote:
> On Sat, Jan 30, 2010 at 11:31:48AM -0500, Michael Breuer wrote:
>    
>> On 01/28/2010 06:36 PM, Stephen Hemminger wrote:
>>      
>>> Please try this patch (and only this patch), on 2.6.33-rc5[*];
>>> none of the other patches that did not make it upstream because that
>>> confuses things too much.
>>>
>>> The code that checks for DMA mapping errors on receive buffers would
>>> not handle errors correctly.  I doubt you have these errors, but if you
>>> did then it would explain the problems.  The code has to be a little
>>> tricky and build mapping for new rx buffer before releasing old one,
>>> that way if new mapping fails, the old one can be reused.
>>>
>>> If it works for you, I will resubmit with signed-off.
>>>
>>> -
>>>
>>>        
>> Nope - tx crash again. This time the system stayed up (but hosed)
>> for a few hours. When I tried to recover eth0 the system then
>> crashed.
>>
>> Brief summary of events (log extract below):
>>
>> System start Jan 28 19:29
>> Everything seemed good (load and all) until 17:13:11 the following
>> day when I got rx errors:
>>
>> Jan 29 17:13:11 mail kernel: sky2 eth0: rx error, status 0x6230010
>> length 1518
>> Jan 29 17:13:11 mail kernel: sky2 eth0: rx error, status 0x7f40010
>> length 1518
>>      
> These are length errors, but status shows more than 1518, e.g. 2036
> here, unless I miss something. Please, don't use jumbo frames in your
> network until we fully debug it for regular frames (Stephen admitted
> sky2 jumbo might be broken).
>    
MTU was 1500 - not using jumbo frames as they don't work.
> ...
>    
>> As I started looking at logs, the system hung and rebooted. I'm up
>> now with dma debug enabled, however as with 2.6.32.4 num_entries is
>> dropping and I don't think that dma debug will remain enabled long
>> enough to catch a crash.
>>      
> Could you try the patch below to show maybe some other users of
> dma-debug entries?
>
> Jarek P.
> ---
>    
Will do. Note that I'm running with the dma debug filter set to sky2.
