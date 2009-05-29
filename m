Return-Path: <linux-kernel-owner+w=401wt.eu-S1760540AbZE2OCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760540AbZE2OCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757974AbZE2OCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:02:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:62913 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbZE2OCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:02:05 -0400
Message-ID: <4A1FEA72.80109@nokia.com>
Date: Fri, 29 May 2009 17:00:18 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/2] UBIFS: start using hrtimers
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain>	 <20090529150944.8912.95076.sendpatchset@localhost.localdomain> <1243603957.23657.217.camel@twins>
In-Reply-To: <1243603957.23657.217.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 29 May 2009 14:00:23.0373 (UTC) FILETIME=[CF765FD0:01C9E065]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2009-05-29 at 18:09 +0300, Artem Bityutskiy wrote:
>> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> Subject: [PATCH 2/2] UBIFS: start using hrtimers
>>
>> UBIFS uses timers for write-buffer write-back. It is not
>> crucial for us to write-back exactly on time. We are fine
>> to write-back a little earlier or later. And this means
>> we may optimize UBIFS timer so that it could be groped
>> with a close timer event, so that the CPU would not be
>> waken up just to do the write back. This is optimization
>> to lessen power consumption, which is important in
>> embedded devices UBIFS is used for.
>>
>> hrtimers have a nice feature: they are effectively range
>> timers, and we may defind the soft and hard limits for
>> it. Standard timers do not have these feature. They may
>> only be made deferrable, but this means there is effectively
>> no hard limit. So, we will better use hrtimers.
>>
>> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> ---
> 
> Seems sane enough from a hrtimer POV, but isn't this already
> functionality that the VFS/pdflush provide?

And I also have a longer term plan to switch the VFS/pdflush
timer to be a range hrtimer, BTW, just like you suggested
me once.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
