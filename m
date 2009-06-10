Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZFJRQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZFJRQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbZFJRQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:16:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZFJRQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:16:35 -0400
Message-ID: <4A2FE9E1.3020705@zytor.com>
Date: Wed, 10 Jun 2009 10:14:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
References: <1242112482.3283.1.camel@localhost.localdomain>	 <20090512232122.61f2d7c5.akpm@linux-foundation.org>	 <1244227115.2507.3.camel@ht.satnam>  <4A29862D.6030601@zytor.com>	 <1244262225.2449.22.camel@ht.satnam> <1244652044.3295.10.camel@ht.satnam>
In-Reply-To: <1244652044.3295.10.camel@ht.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>
>>> The more I'm thinking about this I think it was a mistake to put cpuid
>>> level: there in the first place, too.  My opinion is increasingly to
>>> leave this to x86info or other user-space tools.
>>>
>> cpuid level is as important as cpu family, model and stepping.
>>
>> For Intel, in some cases cpuid level is more important then cpu family,
>> model and stepping. Like you cannot tell by looking at cpu family, model
>> and stepping which model is new and which is old like 05_01 or 06_1A or
>> 0F_03H ?
>>
>> But by looking at cpuid level and extended cpuid level you can tell
>> which is new and which is old and which supports more features.
>>
>> So cpuid level and extended cpuid level is better scale than cpu family,
>> model and stepping. So I think hiding this valuable information is a
>> crime.
> 
> cpuid level and extended cpuid level tells the information about Intel
> processor model.  Do you still think it is useless and should not be present
> in /proc/cpuinfo .
> 

I think it's pointless, because if you're doing this kind of stuff you
might as well talk to CPUID directly.  We have a CPUID interface
already.  The kernel isn't meant to replicate x86info or any of those
tools -- it really can't, and at that point why stop at x86info... we
could replicate arbitrary applications at that point.

As far as extended CPUID, why only the 0x0000 and 0x8000 ranges?
Transmeta used 0x8086 and VIA uses 0xC000, but we don't even cache those
internally, nevermind display them.

I'm not really all that doctrinal about this, but I'd like to get a
decent answer to the question "where does it stop, *and why*".  It's a
slippery slope, and without a target, it goes on forever.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

