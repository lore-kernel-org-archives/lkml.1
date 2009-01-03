Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbZACPwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbZACPwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 10:52:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZACPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 10:52:08 -0500
Received: from relay3.sgi.com ([192.48.171.31]:41039 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758950AbZACPwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 10:52:06 -0500
Message-ID: <495F89A3.9030002@sgi.com>
Date: Sat, 03 Jan 2009 07:52:03 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PULL] cpumask tree
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu> <495F7D27.8020104@sgi.com> <20090103150634.GA28693@elte.hu> <495F84D8.1070404@sgi.com> <20090103154733.GA8111@elte.hu>
In-Reply-To: <20090103154733.GA8111@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>> Ingo Molnar wrote:
>>> * Mike Travis <travis@sgi.com> wrote:
>>>
>>>>> Once we have figured out the CPU-hotplug lockdep splat (possibly due 
>>>>> to Mike's changes not yours) i'll send it to Linus. Thanks,
>>>>>
>>>>> 	Ingo
>>>> Thanks!  Am working on that now.
>>> do you suspect any of the commits? I'm bisecting it right now but if you 
>>> have bisected it already i wont repeat it.
>>>
>>> 	Ingo
>> I haven't done that yet, I'm just now getting your config to work pre-patches.
>>
>> But yes, I suspect one of the changes to use "work_on_cpu" -- this 
>> usually causes the 2nd call to get_online_cpus().
> 
> i suspect it's:
> 
> | commit 2d22bd5e74519854458ad372a89006e65f45e628
> | Author: Mike Travis <travis@sgi.com>
> | Date:   Wed Dec 31 18:08:46 2008 -0800
> |
> |     x86: cleanup remaining cpumask_t code in microcode_core.c
> 
> as the microcode is loaded during CPU onlining.
> 
> 	Ingo

I think you're right.  You need the coincidence of both writing to the
/sys/devices/system/cpu/cpuX/online file along with the cpu coming up
quickly enough to attempt to load the microcode before the write has
returned.  (Or something similar.)

Btw, I'm resending your "fix ia64" patch shortly.

Thanks,
Mike


