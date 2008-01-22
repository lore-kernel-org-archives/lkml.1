Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbYAVQWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbYAVQWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 11:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYAVQWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 11:22:19 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:46961 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYAVQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 11:22:17 -0500
Message-ID: <479617CA.6050803@oracle.com>
Date: Tue, 22 Jan 2008 08:20:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, lkml <linux-kernel@vger.kernel.org>,
       dipankar@in.ibm.com, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] rcu: fix section mismatch
References: <20080119115643.43236e70.randy.dunlap@oracle.com> <20080119212549.GD29070@uranus.ravnborg.org> <200801211138.38591.rusty@rustcorp.com.au> <20080121153409.7511407e.randy.dunlap@oracle.com> <20080122055201.GA4810@uranus.ravnborg.org>
In-Reply-To: <20080122055201.GA4810@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Jan 21, 2008 at 03:34:09PM -0800, Randy Dunlap wrote:
>> On Mon, 21 Jan 2008 11:38:38 +1100 Rusty Russell wrote:
>>
>>> On Sunday 20 January 2008 08:25:49 Sam Ravnborg wrote:
>>>> On Sat, Jan 19, 2008 at 11:56:43AM -0800, Randy Dunlap wrote:
>>>>> rcu_online_cpu() should be __cpuinit instead of __devinit.
>>>> So if we have:
>>>> CONFIG_HOTPLUG=n
>>>> CONFIG_HOTPLUG_CPU=y
>>>>
>>>> then this is a oops candidate.
>>> At first glance, this can't happen because all CONFIG_HOTPLUG_CPU depends on 
>>> CONFIG_HOTPLUG or selects it, for all archs.
>> Mostly, but arch/mips/ seems to be different (neither depends nor selects)
>> unless it has changed very recently (I looked at 2.6.24-rc8).
> 
> mips has
> 	default n
> 
> So they at least try to turn off this feature.

OK.

ISTM that conflating CONFIG_HOTPLUG and CONFIG_HOTPLUG_CPU is both a
mistake and confusing.  CONFIG_HOTPLUG help text specifically talks
about hot-pluggable devices and /dev.  I can imagine some engineers
saying that CPUs and MEM are (abstract) devices, but I don't think that
most users would go that far, so I think that HOTPLUG and HOTPLUG_CPU
should be totally independent.

-- 
~Randy
