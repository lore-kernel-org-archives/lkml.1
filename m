Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0BRJ5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:57:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab0BRJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:57:14 -0500
Message-ID: <4B7D0ED3.5020409@redhat.com>
Date: Thu, 18 Feb 2010 11:56:35 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Luca Barbieri <luca@luca-barbieri.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>	 <4B7C7023.7060602@zytor.com> <ff13bc9a1002171641w372a587j39632cb856b995f1@mail.gmail.com> <4B7C8E04.6070605@zytor.com>
In-Reply-To: <4B7C8E04.6070605@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 02:47 AM, H. Peter Anvin wrote:
>
>>> Unless the performance advantage is provably very compelling, I'm
>>> inclined to say that this is not worth it.
>>>        
>> There is the advantage of not taking the cacheline for writing in atomic64_read.
>> Also locked cmpxchg8b is slow and if we were to restore the TS flag
>> lazily on userspace return, it would significantly improve the
>> function in all cases (with the current code, it depends on how fast
>> the architecture does clts/stts vs lock cmpxchg8b).
>> Of course the big-picture impact depends on the users of the interface.
>>      
> It does, and I would prefer to not take it until there is a user of the
> interface which motivates the performance.  Ingo, do you have a feel for
> how performance-critical this actually is?
>    

One heavy user is set_64() in the pagetable code.  That's already in an 
expensive operation due to the page fault so the impact will be quite 
low, probably.

-- 
error compiling committee.c: too many arguments to function

