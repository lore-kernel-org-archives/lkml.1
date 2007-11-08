Return-Path: <linux-kernel-owner+w=401wt.eu-S1762633AbXKHTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762633AbXKHTp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758555AbXKHTpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:45:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbXKHTpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:45:18 -0500
Message-ID: <4733673C.6010904@redhat.com>
Date: Thu, 08 Nov 2007 13:45:00 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] markers: modpost
References: <20071015194120.GA22562@redhat.com> <20071015231209.GA18994@Krystal> <20071015235033.321E84D0389@magilla.localdomain> <20071025191722.GA6114@Krystal> <20071026142810.GA14814@redhat.com> <20071101010624.54D8D4D04AE@magilla.localdomain> <20071101024622.GA3343@Krystal> <20071101093725.891F34D04AE@magilla.localdomain> <20071101112407.GA24217@Krystal> <47336413.5030505@redhat.com> <20071108193617.GA31172@Krystal>
In-Reply-To: <20071108193617.GA31172@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * David Smith (dsmith@redhat.com) wrote:
>> Mathieu Desnoyers wrote:
>>> * Roland McGrath (roland@redhat.com) wrote:
>>>>> If we want to do it safely, I think we should iterate from
>>>>> __start___markers to __stop___markers symbols of vmlinux and get the
>>>>> pointers to the name/format string pairs.
>>>>>
>>>>> The same can then be done with modules using the __markers section.
>>>>>
>>>>> Or maybe is there some reason not to do that ?
>>>> It's just rather a pain in the ass, a whole lot more fiddly work.
>>>> cf "somewhat crude" and "foreseeable future" in my patch's log entry.
>>>> Knock yourself out if you're looking for more tedious hacking to do in
>>>> modpost.c, but I say fix it when it breaks.
>>>>
>>> Hmmmm, I have rarely seen code go into mainline without addressing valid
>>> technical criticism first. Please fix.
>>>
>>> I'll look into it if I find the time.
>>>
>>> Mathieu
>> Mathieu,
>>
>> Here's an updated patch, written by Roland (that I tested for him), that
>> looks for all marker symbols in the __markers_strings section.  It doesn't
>> get the pointers from the __markers section because that is very difficult
>> to do in modpost (having to handle the architecture-dependent relocations
>> applied to those pointers).
>>
> 
> Hrm, what would happen if a gcc optimization eventually decides to mix
> the memory layout of the strings ? Is there something that specifies
> that they won't ?

I don't believe there is anything in gcc that specifies that the strings
won't get mixed around.  But, I believe this code is good for the
foreseeable future.  We could fix this code if the future breakage does
happen.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
