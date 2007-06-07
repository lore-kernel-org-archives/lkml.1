Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbXFGIKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbXFGIKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXFGIKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:10:40 -0400
Received: from lucidpixels.com ([75.144.35.66]:35263 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbXFGIKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:10:39 -0400
Date: Thu, 7 Jun 2007 04:10:38 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061634.00937.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706070410090.28913@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <20070606161103.f8e3b253.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0706061915090.2716@p34.internal.lan> <200706061634.00937.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 4:15 pm Justin Piszcz wrote:
>> On Wed, 6 Jun 2007, Randy Dunlap wrote:
>>> On Wed, 6 Jun 2007 18:54:37 -0400 (EDT) Justin Piszcz wrote:
>>>> Hm, not sure if it was from the patch or what but I ran this:
>>>>
>>>> 1. swapoff -a
>>>> 2. ./eatmem
>>>
>>> You usually have to access the allocated memory, like:
>>>
>>> 	*d = 1.0;
>>>
>>> for it to actually be allocated (AFAIK).
>>>
>>>>    }
>>>>
>>>>    return 0;
>>>> }
>>>>
>>>> Any idea why the OOM killer can or does not kill it?
>>>
>>> What are the values of /proc/sys/vm/overcommit* ?
>>>
>>> See Documentation/vm/overcommit-accounting .
>>
>> They should be the defaults as I do not change them:
>>
>> p34:~# find /proc/|grep -i overcommit
>> /proc/sys/vm/overcommit_memory
>> /proc/sys/vm/overcommit_ratio
>> find: /proc/5128: No such file or directory
>> p34:~# cat /proc/sys/vm/overcommit_memory
>> 0
>> p34:~# cat /proc/sys/vm/overcommit_ratio
>> 50
>> p34:~#
>>
>>
>> Comments?
>
> You can be sure your memory is available if reported in /proc/meminfo or
> at boot, since those represent the actual kernel data structures used
> for memory allocation:
>
> [    0.000000] On node 0 totalpages: 2061783
>
> That corresponds to 2061783*4k = 8445063168 bytes or ~8053M.  Is that
> fairly close to what's actually installed in the machine?
>
> Note that your boot also mentions this:
>
> [  106.449661] mtrr: no more MTRRs available
>
> which indicates that things like X may not be able to map the
> framebuffer with the 'write-combine' attribute, which will hurt
> performance.  I've heard reports that turning of 'Intel QST fan
> control' in your BIOS settings will prevent all your MTRRs from being
> used (improperly, probably another BIOS bug) so that X will perform
> well.  But if you don't use X on this machine, you don't have to worry
> about it.  The other option would be to remap your MTRRs by hand to
> free one up for X, you can do that by combining the last one or two
> entries into a single MTRR using the API described in
> Documentation/mtrr.txt before you start X.
>
> Jesse
>

FYI--

[  106.449661] mtrr: no more MTRRs available

This has always occurred, even with mem=8832M setting.

Justin.
