Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbZEDUxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbZEDUxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 16:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZEDUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 16:52:51 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56134 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbZEDUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 16:52:50 -0400
Message-ID: <49FF5545.6090205@redhat.com>
Date: Mon, 04 May 2009 17:51:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
       greg@kroah.com, mingo@elte.hu, tglx@linutronix.de,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/21] x86: add methods for writing of an MSR on several
 CPUs
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-2-git-send-email-borislav.petkov@amd.com> <49F890D0.7000109@zytor.com> <20090504164614.GA21710@aftab> <49FF24F8.5050008@zytor.com> <20090504175319.GA23543@aftab>
In-Reply-To: <20090504175319.GA23543@aftab>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov escreveu:
> On Mon, May 04, 2009 at 10:25:12AM -0700, H. Peter Anvin wrote:
>   
>> Borislav Petkov wrote:
>>     
>>>> Please, for the love of God, no!
>>>>
>>>> Make it an array of u64s or (equivalently!) an array of (l,h)
>>>> structures, not separate arrays for the halves of the register.
>>>>         
>>> how about something like the following then? If there's agreement I could
>>> convert all users to struct msr later.
>>>
>>>       
>> I personally would prefer if you just used an array of u64s.  The whole
>> l/h split for MSRs was a mistake in the first place.
>>     
>
> ... on the other hand, the two u32s kinda resemble more the EDX:EAX
> register pair of rdmsr/wrmsr, hm...
>
> [..]
>
>   
>> Or fancier, using gcc's anonymous structs/unions:
>>
>> struct msr {
>> 	union {
>> 		struct {
>> 			u32 l, h;
>> 		};
>> 		u64 q;
>> 	};
>> };
>>     
>
> yeah, that sounds good:
>
> --
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Wed, 29 Apr 2009 15:20:11 +0200
> Subject: [PATCH 1/2] x86: add methods for writing of an MSR on several CPUs
>
> Add a struct representing a 64bit MSR pair consisting of a low and high
> register part.
>
> Also, rename msr-on-cpu.c to msr.c accordingly.
>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>
>   
That sounds good also to me.

Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>

