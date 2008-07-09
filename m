Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbYGIQNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbYGIQNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbYGIQMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:12:55 -0400
Received: from gw.goop.org ([64.81.55.164]:41164 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbYGIQMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:12:54 -0400
Message-ID: <4874E379.3060609@goop.org>
Date: Wed, 09 Jul 2008 09:12:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 00 of 55] xen64: implement 64-bit Xen support
References: <patchbomb.1215554782@localhost> <20080709111219.GA24874@elte.hu>
In-Reply-To: <20080709111219.GA24874@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> thanks Jeremy, applied.
>
> Since they depend on the generic-ipi infrastructure changes, i've 
> created a separate, new tip/xen-64bit branch. The tip/x86/xen-64bit got 
> merged into tip/x86/core and thus is headed for upstream. I have added 
> your patches to the new topic branch - see the shortlog further below.
>   

Speaking of generic-ipi, did you see the bugfix I posted for 
generic_smp_function_interrupt the other day?

I'm also seeing bad pointer dereferences in 
generic_smp_function_interrupt with some kernel configurations, which 
look like RCU failures (either oopses on following the next pointer in 
the list, or a bad function pointer for the call).  Other kernel configs 
are completely stable.  I haven't identified what the difference between 
working and not working is yet.

>> Following that are the Xen-specific changes to implement 64-bit 
>> support.  It works fairly well, but I know of a couple of bugs:
>>
>>  - 32-bit emulation doesn't work properly yet.  Something goes wrong
>>    with %gs, and a userspace %gs: reference segfaults.
>>
>>  - It crashes when bringing up secondary CPUs under some combinations
>>    of config.  I think it isn't quite setting up all the CPU sibling
>>    topology stuff for the various scheduler policies.  It's trying to
>>    set up the most simple of arrangements (every CPU is a singleton
>>    with no shared cache or anything else).  It was quite tricky to
>>    arrange this...
>>
>> I hope to have followup patches to address both of these in the next 
>> couple of days.  I expect both fixes will be small.
>>     
>
> that's OK, it should only affect 64-bit Xen, correct?
>   

Yep.  And if you avoid those two problem areas, it all seems pretty 
stable (16 vcpu kernbench runs with no problems, etc).

> Right now we need to get the generic impact of these patches tested, 
> fixes to xen64 functionality can be done later on in an add-on manner.
>
> Testing: i've done a trial merge of tip/xen-64bit to tip/master - not 
> pushed out yet. If it holds up in testing i'll put the integration rule 
> into tip/master.
>
> tip/xen-64bit (which i've just pushed out) can be cleanly git-merged 
> into tip/master, so if you send updates then please send it against such 
> a merged tree - even if tip/master does not have tip/xen-64bit yet. 
> These patches will need at least half a day of testing before i can push 
> them out.
>   

OK, thanks.

    J
