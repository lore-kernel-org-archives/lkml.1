Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbZKMIFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbZKMIFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZKMIFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:05:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33096 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbZKMIFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:05:03 -0500
Message-ID: <4AFD1326.506@zytor.com>
Date: Fri, 13 Nov 2009 00:04:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, "Ma, Ling" <ling.ma@intel.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] [X86] performance improvement for memcpy_64.S by
 fast string.
References: <1257500482-16182-1-git-send-email-ling.ma@intel.com> <4AF457E0.4040107@zytor.com> <4AF4784C.5090800@zytor.com> <8FED46E8A9CA574792FC7AACAC38FE7714FCF772C9@PDSMSX501.ccr.corp.intel.com> <4AF7C66C.6000009@zytor.com> <20091109080830.GI453@elte.hu> <20091112121619.GD1394@ucw.cz> <20091113073340.GA26127@elte.hu>
In-Reply-To: <20091113073340.GA26127@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 11:33 PM, Ingo Molnar wrote:
> 
> * Pavel Machek <pavel@ucw.cz> wrote:
> 
>>> Ling, if you are interested, could you send a user-space test-app to 
>>> this thread that everyone could just compile and run on various older 
>>> boxes, to gather a performance profile of hand-coded versus string ops 
>>> performance?
>>>
>>> ( And i think we can make a judgement based on cache-hot performance
>>>   alone - if then the strings ops will perform comparatively better in
>>>   cache-cold scenarios, so the cache-hot numbers would be a conservative
>>>   estimate. )
>>
>> Ugh, really? I'd expect cache-cold performance to be not helped at all 
>> (memory bandwidth limit) and you'll get slow down from additional 
>> i-cache misses...
> 
> That's my point - the new code is shorter, which will run comparatively 
> faster in a cache-cold environment.
> 

memcpy_c by itself is by far the shortest variant, of course.

The question is if it makes sense to use the long variants for short (<
1024 bytes) copies.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

