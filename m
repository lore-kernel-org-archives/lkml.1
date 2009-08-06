Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbZHFJKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbZHFJKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZHFJKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:10:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZHFJKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:10:10 -0400
Message-ID: <4A7A9E54.60705@redhat.com>
Date: Thu, 06 Aug 2009 17:11:48 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
References: <20090805112123.6552.73574.sendpatchset@localhost.localdomain>	<m1eirqtmey.fsf@fess.ebiederm.org>	<20090805140408.GJ7259@hmsreliant.think-freely.org>	<m1skg5vpgg.fsf@fess.ebiederm.org> <4A7A3A78.7080200@redhat.com>	<m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com>	<m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com>	<m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com> <m1iqh1nxv3.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqh1nxv3.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Amerigo Wang <amwang@redhat.com> writes:
>   
>> Yes, exactly, in fact I am doing another part which will allow us to take back
>> of the reserved memory at run-time.
>>     
>
> Alright. Let's look at that.
>
> I would make the restriction you can't resize the area while a kexec
> on panic image is loaded, and growing the area would not be a
> realistic option.
>
>   
Sure, I have no plan to do growing reserved memory at run-time... only 
freeing  or shrinking it...

> If crash_kernel=auto happens in the context of being able to shrink
> the area from user space the definition is simple.  We reserve as much
> memory as we think we can without affecting performance, stability,
> reliability.
>
> We can use an initial approximation of perhaps 1/32nd of low memory
> (aka directly mapped memory), and I don't see a point in making the
> code arch dependent at all.  We should run the size approximation past
> the folks on linux-mm as they are more likely to know how much memory
> reduction we can tolerate without problems.
>
>   

Yup, agreed.

> We can then plan on user space saying hey that is more than I need:
> shrink that, and load the kexec on panic kernel.
>   

Exactly... but the interface still needs to be discussed...

Currently, we have two options:

1) add a new flag to kexec_load(2) to tell the kernel to shrink the memory;
2) use /proc/iomem, let the user to decide which and how much of the 
reserved memory should be removed.

Any thoughts?

Thanks.


