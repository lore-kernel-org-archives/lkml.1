Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYIKLTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYIKLTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 07:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYIKLTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 07:19:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:34551 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYIKLTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:19:44 -0400
Message-ID: <48C8FE6F.2070003@kernel.org>
Date: Thu, 11 Sep 2008 13:18:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Austin Zhang <austin_zhang@linux.intel.com>
CC: multinymous@gmail.com, Elias Oltmanns <eo@nebensachen.de>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Laptop shock detection and harddisk protection
References: <48C7FCEE.8060404@kernel.org> <1221128797.30437.4.camel@azhang.bj.intel.com>
In-Reply-To: <1221128797.30437.4.camel@azhang.bj.intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 11 Sep 2008 11:19:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Austin Zhang wrote:
>> 2. If we're gonna unify interface, how much can we unify the backend?
>>    Some devices are based on polling, others interrupt.  For polling,
>>    is it better to delegate the whole polling to userland or is it
>>    better to do some of it in kernel (tp_smapi seems to be doing
>>    this)?
> Shock protection should be time-sensitive, if we put the whole polling 
> into userland, will it be possible that the damage had happened before 
> userland app can signal ATA idle command timely?

Yeah, it's time sensitive but it seems latency of tens of millisecs is
good enough and with mlocked user process, it's really not a problem.

>> 3. What about the userland daemon?  It would be best to have a unified
>>    daemon which can handle all instead of one for hdaps and another
>>    for hp (and so on).  If we can unify the interface, this will be
>>    much easier.
>>
>> Thanks.
> 
> Can this process "acceleration-detect --> inform ATA shock protect --> 
> issue idle command" be done totally in kernel, avoiding to consume too 
> many time for "acceleration-detect --> sysfs --> userland app --> sysfs 
> --> inform ATA shock protect --> issue idle command" before HD was damaged? 
> The userland daemon should be just a indicator (but of course it can pass 
> params to driver) for the protection status rather than a judge.

Again, it doesn't have to be that fast and the judgement part involves
complex floating arithmetics + user usage patterns (has the user typed
something recently, is lid closed kind of stuff).  I don't think it
fits in kernel.

Thanks.

-- 
tejun
