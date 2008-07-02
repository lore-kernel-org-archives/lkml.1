Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYGBOES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYGBOES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYGBOEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:04:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47796 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752671AbYGBOEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:04:07 -0400
Message-ID: <486B8AD3.70007@sgi.com>
Date: Wed, 02 Jul 2008 07:04:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] percpu: Optimize percpu accesses
References: <20080701121634.865966000@polaris-admin.engr.sgi.com> <20080701145417.GB18522@elte.hu> <20080701150313.GA30476@elte.hu> <486A483B.2090804@sgi.com>
In-Reply-To: <486A483B.2090804@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>>> This patchset provides the following:
>>>>
>>>>   * Cleanup: Fix early references to cpumask_of_cpu(0)
>>>>   * Generic: Percpu infrastructure to rebase the per cpu area to zero
>>>>   * x86_64: Fold pda into per cpu area
>>>>   * x86_64: Rebase per cpu variables to zero
>>> thanks Mike - i've started testing it in -tip. One small merge fallout 
>>> fix is below. (it's for the new generic-ipi topic that was not in 
>>> tip/master yet when you merged percpu-zerobased to it)
>> ok, -tip testing found an early boot crash caused by your patchset, on 
>> 64-bit x86:

Hi Ingo,

Which gcc version are you using?

Thanks,
Mike

>>
>> [    0.396000] calling  net_ns_init+0x0/0x143
>> [    0.400000] net_namespace: 944 bytes
>> [    0.403578] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> [    0.404000] IP: [<ffffffff80e05b0e>] net_ns_init+0x9f/0x143
>> [    0.404000] PGD 0
>> [    0.404000] Oops: 0000 [1] SMP
>> [    0.404000] CPU 0
>> [...]
>>
>> full bootlog and config can be found at:
>>
>>   http://redhat.com/~mingo/misc/crashlog-Tue_Jul__1_16_48_45_CEST_2008.bad
>>   http://redhat.com/~mingo/misc/config-Tue_Jul__1_16_48_45_CEST_2008.bad
>>
>> (another 64-bit testbox crashed as well, so this should be readily 
>> reproducible.)
>>
>> i've pushed this tree out to tip/tmp.core/percpu-zerobased.Jul__1_16_48 
>> topic branch, that is the 2.6.26-rc8-tip-00250-g90874b0 kernel you can 
>> see in the crashlog.
>>
>> 	Ingo
> 
> Wow, that was quick!
> 
> At least this one gets to someplace debuggable.  Some others that don't
> even get to the first "kernel alive" messages are really annoying.  ;-)
> 
> Thanks,
> Mike

