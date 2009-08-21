Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZHUSXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZHUSXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbZHUSXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:23:02 -0400
Received: from mga05.intel.com ([192.55.52.89]:46540 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755594AbZHUSXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:23:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,251,1249282800"; 
   d="scan'208";a="486082815"
Message-ID: <4A8EE606.7000807@linux.intel.com>
Date: Fri, 21 Aug 2009 11:23:02 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Tobias Doerffel <tobias.doerffel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Kelly Bowa <kelly.bowa@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Atom processor inclusion
References: <20090820130648.6e7236f7@titus> <20090820105029.GF29093@elte.hu> <200908201433.54785.tobias.doerffel@gmail.com> <4A8EE544.6020002@zytor.com>
In-Reply-To: <4A8EE544.6020002@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 08/20/2009 05:33 AM, Tobias Doerffel wrote:
>> Hi,
>>
>> Am Donnerstag, 20. August 2009 12:50:29 schrieb Ingo Molnar:
>>> Yep, it looked acceptable - Tobias, do you have any
>>> updates / latest version of that patch?
>> No - it's still the improved version I posted at the end of May [1]. The 
>> question is what to do with MODULE_PROC_FAMILY (CORE2 or ATOM) and the mtune-
>> fallback (generic, i686, ...)?
>>
> 
> Without benchmarks, we're flying blind on that one... although in
> general, "generic" is probably best in the sense that it doesn't imply
> that anything else has been done to it.
> 
> As far as MODULE_PROC_FAMILY it really comes down to if we use movbe or
> not, which I don't believe your patch does.  On the other hand, I really
> think it's extremely unlikely that anyone will use modules compiled for
> a different CPU, so I'm personally fine with changing that string.
> 
> That whole mechanism is kind of broken, anyway.
> 

personally, I would prefer it if we did a simple hash of the WHOLE cflags,
and put that into the module version string.
Anything else is just a weak, and useless, substitute for that.

Using different CFLAGS in any shape or form should disqualify the module
as "incompatible".. and a simple hash is sufficient for that.....
