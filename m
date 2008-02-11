Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbYBKVo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbYBKVo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYBKVot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:44:49 -0500
Received: from mail.tmr.com ([64.65.253.246]:36485 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbYBKVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:44:48 -0500
Message-ID: <47B0C1E8.2050809@tmr.com>
Date: Mon, 11 Feb 2008 16:45:12 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Willy Tarreau <w@1wt.eu>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Scheduler(?) regression from 2.6.22 to 2.6.24 for short-lived
   threads
References: <20080209000456.GA21021@lixom.net> <1202543920.9578.3.camel@homer.simson.net> <20080209080319.GO8953@1wt.eu> <1202554705.10287.12.camel@homer.simson.net> <20080209114009.GP8953@1wt.eu> <1202564259.4035.18.camel@homer.simson.net> <20080209161957.GA3364@1wt.eu> <20080210052941.GA4731@lixom.net>
In-Reply-To: <20080210052941.GA4731@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:

>> However, I fail to understand the goal of the reproducer. Granted it shows
>> irregularities in the scheduler under such conditions, but what *real*
>> workload would spend its time sequentially creating then immediately killing
>> threads, never using more than 2 at a time ?
>>
>> If this could be turned into a DoS, I could understand, but here it looks
>> a bit pointless :-/
> 
> It seems generally unfortunate that it takes longer for a new thread to
> move over to the second cpu even when the first is busy with the original
> thread. I can certainly see cases where this causes suboptimal overall
> system behaviour.
> 
I think the moving to another CPU gets really dependent on the CPU type. 
On a P4+HT the caches are shared, and moving costs almost nothing for 
cache hits, while on CPUs which have other cache layouts the migration 
cost is higher. Obviously multi-core should be cheaper than 
multi-socket, by avoiding using the system memory bus, but it still can 
get ugly.

I have an IPC test around which showed that, it ran like hell on HT, and 
progressively worse as cache because less shared. I wonder why the 
latest git works so much better?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
