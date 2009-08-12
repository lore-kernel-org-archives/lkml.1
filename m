Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZHLBaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZHLBaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZHLBav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:30:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55264 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZHLBav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:30:51 -0400
Message-ID: <4A821BBC.6070208@redhat.com>
Date: Wed, 12 Aug 2009 09:32:44 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Neil Horman <nhorman@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC Patch 2/2] kexec: allow to shrink reserved memory
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain> <20090811104154.5154.78710.sendpatchset@localhost.localdomain> <20090811104606.GA26587@hmsreliant.think-freely.org>
In-Reply-To: <20090811104606.GA26587@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Tue, Aug 11, 2009 at 06:39:32AM -0400, Amerigo Wang wrote:
>   
>> This patch implements shrinking the reserved memory for crash kernel,
>> if it is more than enough.
>>
>> For example, if you have already reserved 128M, now you just want 100M,
>> you can do:
>>
>> # echo $((100*1024*1024)) > /sys/kernel/kexec_crash_size
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Neil Horman <nhorman@redhat.com>
>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>> Cc: Andi Kleen <andi@firstfloor.org>
>>
>>     
>
> Since the reserved area is also used for heap in the new kernel, isn't this
> mechanism going to guarantee a non-bootable kernel.  It seems like it shrinks
> the reserved area to the size of the image, leaving no additional memory for
> heap allocations during the kernels boot.  Or am I missing something?
>   

Hmm, you mean we should also make some more memory for the heap that is 
"unfreeable" via this?? Good point, but the size for the heap of the 
crash kernel is not so easy to decide...

Thanks!


