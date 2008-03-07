Return-Path: <linux-kernel-owner+w=401wt.eu-S932353AbYCGMeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbYCGMeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758547AbYCGMeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:34:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48414 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbYCGMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:34:04 -0500
Message-ID: <47D1352F.6010504@zytor.com>
Date: Fri, 07 Mar 2008 04:29:35 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080304012012.GB22431@infradead.org> <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu> <20080306202446.GA4225@ucw.cz>
In-Reply-To: <20080306202446.GA4225@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2008-03-06 16:51:41, Ingo Molnar wrote:
>> * Pavel Machek <pavel@ucw.cz> wrote:
>>
>>>>> kmem_cache_alloc() can fail (return NULL) and not handling it is a 
>>>>> bug.
>>>> oops. you are correct. Will send a sigsegv in the failure case then. 
>>>> Thanks.
>>> You are introducing possibility of hard to debug error, where previous 
>>> code just worked... Does not look like good idea to me.
>> hm, how does it differ from any other allocation failure? We could fail 
> 
> Well, we should not be sending SIGSEGV...? SIGBUS would be cleaner, or
> SIGKILL... what happens when userland tries to catch this one?
> 

I'm confused...

Normally when we need memory for userspace and can't get it, we put the 
process to sleep until memory is available.

Why is this different in any way?

	-hpa
