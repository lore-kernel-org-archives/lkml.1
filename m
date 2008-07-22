Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbYGVNqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbYGVNqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 09:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYGVNqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 09:46:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49154 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYGVNqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 09:46:15 -0400
Date: Tue, 22 Jul 2008 15:46:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, jfm3 <jfm3@winlab.rutgers.edu>,
       Sujith <m.sujith@gmail.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot
	boot
Message-ID: <20080722134601.GA21977@elte.hu>
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com> <48848DDF.6010903@zytor.com> <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com> <48851AC2.8030007@zytor.com> <20080722131408.GA12418@elte.hu> <4885DF9D.2090804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885DF9D.2090804@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Ingo Molnar wrote:
>>>
>>> Not a bug.
>>
>> it would still be nice to get a nice printk and panic during bootup  
>> instead of some obscure crash, hm?
>>
>
> Yes.  The fundamental problem is that Centaur has a set of CPUs which 
> report family == 6 but don't have the long NOP instructions.  We would 
> need an exact CPUID criterion for these CPUs in order to be able to 
> report it as an error.  An alternative would be to attempt trapping in 
> the real-mode code (#UD is one of the *very* few CPU exceptions which 
> can be reliably captured in real mode on a BIOS system), but doing so 
> would probably mean breaking Loadlin at the very least.
>
> We can't "printk and panic" because we never get that far in the 
> kernel proper, for obvious reasons: the code is quite littered with 
> these buggers.

hm. How about to default to a safe NOP all the way up to where we can 
fix up alternatives and install a different NOP. (which we could also 
test first via intentionally jumping on it and catching any exception 
via a special exception handler)

	Ingo
