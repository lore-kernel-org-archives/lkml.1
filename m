Return-Path: <linux-kernel-owner+w=401wt.eu-S1763503AbZE3TYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763503AbZE3TYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 15:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757977AbZE3TYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 15:24:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39675 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbZE3TYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 15:24:47 -0400
Message-ID: <4A2187BF.1070205@zytor.com>
Date: Sat, 30 May 2009 12:23:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org> <20090530112234.GB1395@ucw.cz> <200905300713.23741.lkml@morethan.org>
In-Reply-To: <200905300713.23741.lkml@morethan.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> On Sat May 30 2009, Pavel Machek wrote:
>> Hi!
>>
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -1535,6 +1535,10 @@ and is between 256 and 4096 characters. It is defined in the file
>>>  			register save and restore. The kernel will only save
>>>  			legacy floating-point registers on task switch.
>>>  
>>> +	noxsave		[BUGS=X86] Disables x86 extended register state save
>>> +			and restore using xsave. The kernel will fallback to
>>> +			enabling legacy floating-point and sse state.
>>> +
>> Does that mean apps using sse8 will see their registers corrupted if
>> this option is used? Or are new registers sets always added in a way
>> that kernel has to enable them first?

New register sets always require enabling.

> Has this change been tested on the processors that have independent ftp&sse
> units, without the shared registers?  Such as the VIA C7-M?

x87 and SSE are always separate.  Whether or not register sets are
separate is an architectural issue, and isn't subject to variation
across CPUs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

