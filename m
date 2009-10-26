Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZJZSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZJZSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbZJZSZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:25:29 -0400
Received: from relay3.sgi.com ([192.48.152.1]:52259 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752360AbZJZSZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:25:28 -0400
Message-ID: <4AE5E9A0.1020009@sgi.com>
Date: Mon, 26 Oct 2009 11:25:36 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Andreas Mohr <andi@lisas.de>,
       Hugh Dickins <hugh@veritas.com>, Hannes Eder <hannes@hanneseder.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] SGI x86_64 UV: Limit the number of microcode messages
References: <20091023233743.439628000@alcatraz.americas.sgi.com>	 <20091023233756.941535000@alcatraz.americas.sgi.com>	 <b647ffbd0910241309u7b2f8c94t1f886ef31882539e@mail.gmail.com>	 <Pine.LNX.4.61.0910242207180.2439@ginsburg.homenet> <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
In-Reply-To: <b647ffbd0910241545g4697a170peb00e541298d5a30@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Dmitry Adamushko wrote:
> 2009/10/24 Tigran Aivazian <tigran@aivazian.fsnet.co.uk>:
>> On Sat, 24 Oct 2009, Dmitry Adamushko wrote:
>>>> -       printk(KERN_INFO "microcode: CPU%d sig=0x%x, pf=0x%x,
>>>> revision=0x%x\n",
>>>> +       if (cpu_num < 4 || !limit_console_output(false))
>>>> +               printk(KERN_INFO
>>>> +                       "microcode: CPU%d sig=0x%x, pf=0x%x,
>>>> revision=0x%x\n",
>>>>                        cpu_num, csig->sig, csig->pf, csig->rev);
>>>>
>>> Hmm, I guess we wouldn't lose a lot by simply removing those messages
>>> completely. Per-cpu pf/revision is available via /sys anyway.
>> The reason for printing them is that the pf (possibly others?) can change by the update and so the log has this info handy.
> 
> We might store the old sig/pf/revision set as well, export them via
> /sys or/and print them at update-to-new-microcode time.
> 
> If it's really so useful to have this info in the log and, at the same
> time, to avoid the flood of messages (which, I guess for the majority
> of systems, are the same) at startup time, we might delay the printout
> until the end of microcode_init(). Then do something like this:
> 
> microcode cpu0: up to date version sig, pf, rev          // let's say,
> it was updated by BIOS
> microcode cpus [1 ... 16] : update from sig, pf, rev to sig, pf2, rev2.
> 
> Anyway, my humble opinion, is that (at the very least) the current
> patch should be accompanied by a similar version for amd.

I could add it for AMD but I can't test it, and I'm always reluctant to
change things I can't verify.

Thanks,
Mike

> 
> 
>> Kind regards
>> Tigran
> 
> 
> -- Dmitry
