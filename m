Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZHFDhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZHFDhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 23:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbZHFDhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 23:37:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36433 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZHFDhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 23:37:50 -0400
Message-ID: <4A7A506B.2060008@redhat.com>
Date: Thu, 06 Aug 2009 11:39:23 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com> <m1y6pxr737.fsf@fess.ebiederm.org>
In-Reply-To: <m1y6pxr737.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> In general I figure that whoever builds the kernel and initrd should be
> responsible for testing and figuring out the amount of memory needed.
> The primary kernel has no idea what is going to loaded in there and
> as such no real idea how much memory is needed.
>   

Yeah, that is exactly why I _didn't_ pick the idea of reserving memory 
automatically and silently without "crashkernel=auto".

If a user specifies "crashkernel=auto", that means he/she has no idea 
how much memory to be reserved, he/she wants to let the kernel to 
decide. Kernel should know better than the user in this situation.

>>> You also have to build (or at least load) the whole kdump image after
>>> the system boots, and configure someplace for this to be saved.
>>>
>>> What class of problems do you expect to catch with this?
>>>   
>>>       
>> Again, try to save the user from choosing numbers for "crashkernel=".
>>     
>
> The user being kernel developers?  Whoever builds the kernel and initrd
> should be responsible for testing and figuring this out.
>
> In a distro context installers etc should be able to setup good defaults
> so end users don't have to worry about this.
>
>   
For kernel developers, "crashkernel=auto" should save a lot. You seem 
agree with this one.

For users, they rely on the distro which can always specify 
"crashkernel=auto" now, not different numbers for different arch, since 
"crashkernel=auto" is designed to be safe for all cases. Also saves many 
work...

>>> What has me puzzled is that the mkdumprd that ships with fedora isn't
>>> usable without patching, and it seems to be steadily getting worse.  
>>>       
>> Please explain why it is not usable? The patch won't break the userspace, since
>> it modifies the "crashkernel=" command line dynamically.
>>     
>
> No the crashdump mechanism is useless because user space is already
> broken and unusable.

Again, why broken?

Thanks.


