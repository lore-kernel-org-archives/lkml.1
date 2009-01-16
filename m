Return-Path: <linux-kernel-owner+w=401wt.eu-S936876AbZAPShu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936876AbZAPShu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 13:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936673AbZAPSh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 13:37:28 -0500
Received: from main.gmane.org ([80.91.229.2]:57895 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936574AbZAPShZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 13:37:25 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Fri, 16 Jan 2009 13:37:10 -0500
Message-ID: <4970D3D6.3040906@tmr.com>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>	 <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>	 <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>	 <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>	 <20090115180844.GL22472@elte.hu>	 <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain> <1232047618.8269.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <1232047618.8269.93.camel@think.oraclecorp.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> On Thu, 2009-01-15 at 10:16 -0800, Linus Torvalds wrote:
>> On Thu, 15 Jan 2009, Ingo Molnar wrote:
>>> btw., i think spin-mutexes have a design advantage here: in a lot of code 
>>> areas it's quite difficult to use spinlocks - cannot allocate memory, 
>>> cannot call any code that can sporadically block (but does not _normally_ 
>>> block), etc.
>>>
>>> With mutexes those atomicity constraints go away - and the performance 
>>> profile should now be quite close to that of spinlocks as well.
>> Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
>> hold the lock over all those unnecessary and complex operations.
>>
> 
> While this is true, there are examples of places we should expect
> speedups for this today.
> 
> Concurrent file creation/deletion in a single dir will often find things
> hot in cache and not have to block anywhere (mail spools).
> 
And although not as common, NNTP servers using file per article storage.

> Concurrent O_DIRECT aio writes to the same file, where i_mutex is
> dropped early on.
> 
> pipes should see a huge improvement.
> 
I'd like to see that. Didn't realize how slow pipes really are.

> I'll kick off some runs of my three benchmarks on ext3 for comparison.
> If there are things less synthetic people would like to see, please let
> me know.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

