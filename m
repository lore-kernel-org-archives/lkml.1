Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYGSRBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYGSRBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbYGSRBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:01:42 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57777 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYGSRBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:01:41 -0400
Message-ID: <48821DEF.1040306@candelatech.com>
Date: Sat, 19 Jul 2008 10:01:35 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [BUG, NET] deadlock tearing down a bridged interface
References: <20080718073724.GA5802@disturbed> <4880BA7A.3020909@candelatech.com> <20080719011709.GA5947@disturbed>
In-Reply-To: <20080719011709.GA5947@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Fri, Jul 18, 2008 at 08:44:58AM -0700, Ben Greear wrote:
>   
>> Dave Chinner wrote:
>>     
>>> Folks,
>>>
>>> I just deadlocked networking on a 2.6.24 kernel. Basically I
>>> was trying to restart the bridge interface I use for UML sessions
>>> because it wasn't passing packets. This happens occasionally
>>> when I leave a UML session too long in gdb, so I bounced the
>>> bridge to get it working again.
>>>   
>>>       
>> We have been chasing a refcount bug in 2.6.25 that only happens when
>> IPv6 module is loaded.
>>     
>
> Which causes what problem? The deadlock I reported or the bridge occasionally
> hanging? Is that a problem in 2.6.24?
>
> The deadlock is the one I'm concerned about - it appears that
> netdev_run_todo() can only wait on a single interface at a time,
> so if we are tearing down two interfaces concurrently where one
> has a reference on the other a deadlock is just waiting to happen...
>   
Our problem is the refcount hang while trying to remove a netdevice.  It 
appears
to be an ipv6 related leakage of some sort, and not directly related to 
bridges.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com> 
Candela Technologies Inc  http://www.candelatech.com


