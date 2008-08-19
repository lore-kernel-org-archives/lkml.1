Return-Path: <linux-kernel-owner+w=401wt.eu-S1755046AbYHSOTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046AbYHSOTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYHSOTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:19:05 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:52757 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbYHSOTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:19:04 -0400
Message-ID: <48AAD680.7020508@keyaccess.nl>
Date: Tue, 19 Aug 2008 16:19:44 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
References: <48972EA8.8040001@keyaccess.nl> <20080815142218.GC12954@elte.hu> <48A59FAC.7050605@keyaccess.nl> <48AA9C3B.5030309@keyaccess.nl> <20080819102633.GE6722@elte.hu>
In-Reply-To: <20080819102633.GE6722@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-08-08 12:26, Ingo Molnar wrote:

> * Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 15-08-08 17:24, Rene Herman wrote:
>>
>>> On 15-08-08 16:22, Ingo Molnar wrote:
>>>
>>>> (more people Cc:-ed)
>>> Thank you. Additional information at http://lkml.org/lkml/2008/8/6/449
>>>
>>>> agreed - +12 seconds wait suggest some rather fundamental breakage.
>>>> Did we go back to uncached for some critical display area that makes
>>>> X start up (shut down) that slowly? Did we mark the BIOS uncacheable
>>>> perhaps, causing X to execute BIOS code very slowly?
>>> Quite a lot "uncached-minus" in those lists. I am desperately trying to 
>>> avoid a clue about mostly anything graphics related so, "I dunno".
>>>
>>> I haven't just disabled PAT yet (although I was about to just do so) 
>>> and am available for testing.
>> <waiting with bated breath>
>>
>> Additional observation with respect to first,next shutdown:
>>
>> With Option "AGPSize" "64", and booted with "nopat", X startup (from 
>> startx<enter> to functional desktop) is approximately 5 seconds, 
>> shutdown is 1 second as calibration times.
>>
>> Booted without "nopat", X startup seems to alternate between 10+ and 
>> 16+ seconds and for shutdown -- the first shutdown after boot takes 
>> some 14 seconds total, subsequent shutdowns settle at around 5 
>> seconds.
> 
> would it be possible to start up and shut down X in the slow case via 
> strace, by doing something like this:
> 
>   strace -f -ttt -TTT -o trace.log startx
> 
> and see which system calls (or other activities) took suspiciously long?

It wouldn't it seems. Root X (needed for the strace) works fine but 
started this way hangs indefinitely.

I believe the 14 seconds for first shutdown to 5 later might be telling. 
Sounds like something might have fixed up uncached entries.

I'd really like a reply from the AGP or PAT side right about now.

Rene.
