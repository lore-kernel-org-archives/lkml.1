Return-Path: <linux-kernel-owner+w=401wt.eu-S1764463AbYCGNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764463AbYCGNKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758349AbYCGNJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:09:50 -0500
Received: from mga06.intel.com ([134.134.136.21]:40911 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756529AbYCGNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:09:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,462,1199692800"; 
   d="scan'208";a="351336277"
Message-ID: <47D13DEF.6030006@linux.intel.com>
Date: Fri, 07 Mar 2008 07:06:55 -0600
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu> <20080306202446.GA4225@ucw.cz> <47D1352F.6010504@zytor.com>
In-Reply-To: <47D1352F.6010504@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Pavel Machek wrote:
>> On Thu 2008-03-06 16:51:41, Ingo Molnar wrote:
>>> * Pavel Machek <pavel@ucw.cz> wrote:
>>>
>>>>>> kmem_cache_alloc() can fail (return NULL) and not handling it is a 
>>>>>> bug.
>>>>> oops. you are correct. Will send a sigsegv in the failure case 
>>>>> then. Thanks.
>>>> You are introducing possibility of hard to debug error, where 
>>>> previous code just worked... Does not look like good idea to me.
>>> hm, how does it differ from any other allocation failure? We could fail 
>>
>> Well, we should not be sending SIGSEGV...? SIGBUS would be cleaner, or
>> SIGKILL... what happens when userland tries to catch this one?
>>
> 
> I'm confused...
> 
> Normally when we need memory for userspace and can't get it, we put the 
> process to sleep until memory is available.

that's what GFP_KERNEL does
> 
> Why is this different in any way?

this is just for handling the case where that fails
(basically near/totally OOM or the case where you get a fatal signal)

maybe we need a GFP_KILLABLE now that we have a TASK_KILLABLE...

