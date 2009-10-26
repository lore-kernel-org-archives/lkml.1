Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZJZSYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZJZSYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZJZSYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:24:14 -0400
Received: from relay3.sgi.com ([192.48.152.1]:35260 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753543AbZJZSYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:24:13 -0400
Message-ID: <4AE5E95A.9050508@sgi.com>
Date: Mon, 26 Oct 2009 11:24:26 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: Dmitry Adamushko <dmitry.adamushko@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>  <20091023233756.941535000@alcatraz.americas.sgi.com> <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com> <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
In-Reply-To: <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tigran Aivazian wrote:
> On Sat, 24 Oct 2009, Dmitry Adamushko wrote:
>>> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x, 
>>> revision=0x%x\n",
>>> +       if (cpu_num < 4 || !limit_console_output(false))
>>> +               printk(KERN_INFO
>>> +                       "microcode: CPU%d sig=0x%x, pf=0x%x, 
>>> revision=0x%x\n",
>>>                        cpu_num, csig->sig, csig->pf, csig->rev);
>>>
>>
>> Hmm, I guess we wouldn't lose a lot by simply removing those messages
>> completely. Per-cpu pf/revision is available via /sys anyway.
> 
> The reason for printing them is that the pf (possibly others?) can 
> change by the update and so the log has this info handy.
> 
> Kind regards
> Tigran

Is there any reason to need this on the console before being able to
look at them with dmesg?  (Or use some filter program to hunt through
the system log?)

And if all the cpus are the same, would the printing of each one give
you any more information?  I could add something that attempts to
print the new line if it's different than the previous, but this would
add complexity, maybe unnecessarily?   And I was going for an approach
that optimizes to zero code when not enabled.

Thanks,
Mike
