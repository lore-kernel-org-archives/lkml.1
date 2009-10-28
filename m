Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZJ1G0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZJ1G0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 02:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZJ1G0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 02:26:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbZJ1G0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 02:26:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AE7E40F.20602@jp.fujitsu.com>
Date: Wed, 28 Oct 2009 15:26:23 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Mike Travis <travis@sgi.com>, Roland Dreier <rdreier@cisco.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH] x86, mce: disable MCE if cpu has no MCE banks
References: <adaeip473qt.fsf@cisco.com> <4AE74D25.8090901@sgi.com> <4AE75DB9.3040702@sgi.com> <4AE7C396.7040109@jp.fujitsu.com> <4AE7D59D.9070307@linux.intel.com>
In-Reply-To: <4AE7D59D.9070307@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Hidetoshi Seto wrote:
>> Mike Travis wrote:
>>> Mike Travis wrote:
>>>> Hi Roland,
>>>>
>>>> I've found that I'm getting one of these lines for every cpu:
>>>>
>>>> mce: CPU supports 0 MCE banks
> 
> That message can be just removed I think. I don't see much value in it
> because the value is in sysfs and when you see the CPU type you can easily
> determine it anyways.
> 
> I don't think the patch below really solves the problem because they
> would have the same noise problem back once they switch from the simulator
> to a real box which has banks.

If box has any banks more than 0, then the line above will be appeared only
once for CPU 0.  Only on the simulator, with MCE-capable processor with no
bank, this message becomes unacceptable noise because it appears for every
cpu.

Anyway I think my patch is nice to have, to avoid unexpected behavior on
uncertain environment.  

Without disabling, what can we do on MCE with no bank?
I found that do_machine_check() does nothing if banks==0 ... it is better
to let system to panic with "Machine check from unknown source"?


>> Hum, I suppose the line for CPU 0 was slightly different from others,
>> because SHD means "this bank is shared bank and controlled by other".
>> Maybe:
>>  CPU 0 MCA banks CMCI:0 CMCI:1 CMCI:2 CMCI:3 CMCI:5 ... CMCI:21
>>
>> But I agree that we could some work for this messages...
>> Is it better to change the message level to debug from info?
> 
> Can be made INFO yes, but I would prefer not removing them
> from the dmesg for now.
> 
> Perhaps they could be also compressed a bit like SRAT.

Like SRAT?  I could not catch the meaning ... For example?


Thanks,
H.Seto

