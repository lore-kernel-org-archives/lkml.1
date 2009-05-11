Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbZEKPGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbZEKPGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756405AbZEKPGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:06:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57420 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961AbZEKPGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:06:33 -0400
Message-ID: <4A083EE4.6000607@redhat.com>
Date: Mon, 11 May 2009 18:06:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com>	 <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com>	 <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu>	 <4A083539.407@redhat.com> <20090511143320.GE6175@elte.hu>	 <4A083B69.6010702@redhat.com> <1242054109.11251.276.camel@twins>
In-Reply-To: <1242054109.11251.276.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>>> This really needs a new kernel-internal scheduler API though, which 
>>> does a lot of fancy things to do:
>>>
>>>         se->vruntime += 1000000;
>>>
>>> i.e. add 1 msec worth of nanoseconds to the task's timeline. (first 
>>> remove it from the rbtree, then add it back, and nice-weight it as 
>>> well) 
>>>       
>> I suspected it would be as simple as this.
>>     
>
> Is that thread guaranteed to run as SCHED_OTHER?
>   

No, it's user specified.  But if it isn't SCHED_OTHER, we don't mind if 
it spins (and we hope realtime systems aren't overcommitted).

-- 
error compiling committee.c: too many arguments to function

