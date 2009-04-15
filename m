Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbZDOVIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbZDOVIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 17:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbZDOVIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 17:08:35 -0400
Received: from brinza.cc.columbia.edu ([128.59.29.8]:53999 "EHLO
	brinza.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZDOVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 17:08:35 -0400
Message-ID: <49E64BFF.5080002@cs.columbia.edu>
Date: Wed, 15 Apr 2009 17:05:03 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: CAP_SYS_ADMIN on restart(2)
References: <20090410023207.GA27788@x200.localdomain>	<1239340031.24083.21.camel@nimitz>	<20090413091423.GA19236@x200.localdomain>	<49E4108A.8050201@cs.columbia.edu>	<20090414145830.GA27461@x200.localdomain>	<49E4D115.5080601@cs.columbia.edu>	<20090414204912.GA28458@x200.localdomain>	<20090414213934.GB17986@us.ibm.com>	<20090415192150.GC26994@x200.localdomain>	<1239827033.32604.167.camel@nimitz> <20090415203920.GA5475@us.ibm.com>
In-Reply-To: <20090415203920.GA5475@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
>> On Wed, 2009-04-15 at 23:21 +0400, Alexey Dobriyan wrote:
>>> Is sysctl to control CAP_SYS_ADMIN on restart(2) OK?
>> If the point is not to let users even *try* restarting things if it
>> *might* not work, then I guess this might be reasonable.  
>>
>> If the goal is to increase security by always requiring CAP_SYS_ADMIN
>> for "dangerous" operations, I fear it will be harmful.  We may have
>> people adding features that are not considering the security impact of
>> what they're doing just because the cases they care about all require
>> privilege.
> 
> Nah, I disagree.  (Or put another way, that wouldn't be the goal)
> There are two administrators we want to satisfy:
> 
> 1. the one who wants his users to do partial checkpoints, but doesn't
> want to risk giving away any privilege at all in the process.  He'll
> be satisified by setting restart(2) to not require cap_sys_admin,
> and his users just won't be able to do a whole container.  A lot of
> users will be happy with that (though no SYSVIPC support, then).

There is also a middle way: use setuid program to allow creation
of a new namespace (under your favorite policy), then drop the
privileges and continue as unprivileged inside that container.

IOW, don't make the initial container-creation a barrier for the
entire operation.

Oren.

> 
> 2. the one who may have one or two users who he trusts to do
> checkpoint/restart, but otherwise doesn't want even the slightest
> risk of other users using restart, and maybe finding an exploit.
> That one is probably the more common admin, and he'll be satisified
> with requiring CAP_SYS_ADMIN for all restart(2)'s, since he's ok
> risking giving extra privilege to the ones he trusts.
> 
> And meanwhile, by virtue of leaving (1) supported, we are still
> more under the gun to make sure that everything restart(2) does
> is properly checked.
> 
>> What would the goal be?
>>
>> -- Dave
> 
> -serge
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 
