Return-Path: <linux-kernel-owner+w=401wt.eu-S933709AbXK2Tvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbXK2Tvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932910AbXK2TvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:51:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41343 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbXK2Tu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:50:58 -0500
Date: Thu, 29 Nov 2007 20:50:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH x86/mm 08/11] x86 ia32 ptrace getreg/putreg merge
Message-ID: <20071129195032.GC15245@elte.hu>
References: <20071129115711.9FC8526F8E7@magilla.localdomain> <20071129120031.F0F4F26F989@magilla.localdomain> <20071129173734.GA556@infradead.org> <474EFDF8.8090506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474EFDF8.8090506@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Christoph Hellwig wrote:
>> On Thu, Nov 29, 2007 at 04:00:31AM -0800, Roland McGrath wrote:
>>> +#define R32(l,q)							\
>>> +	case offsetof(struct user32, regs.l):				\
>>> +		regs->q = value; break
>>> +
>>> +#define SEG32(rs)							\
>>> +	case offsetof(struct user32, regs.rs):				\
>>> +		return set_segment_reg(child,				\
>>> +				       offsetof(struct user_regs_struct, rs), \
>>> +				       value);				\
>>> +		break
>>
>> The code would be a lot more readable if you just opencoded this in the
>> caller instead of these obsfucated macros.
>
> For better or worse, though, that is style of existing code.  I 
> personally found it easy to deal with when I went through the code 
> recently.

yep. The ptrace code has certainly lots of inconsistent style crap piled 
up during its 10 year history of only be touched with a 10 foot pole. 
I'd go for small patches that continuously improve the picture within 
the existing mechanisms than any "100% pure required" approach. With 48 
clean patches from Roland we are already on the right granularity level 
i think.

See how ptrace.c raw code quality has already increased leaps and 
bounds:

                                       errors   lines of code   errors/KLOC
 [before]
 arch/x86/kernel/ptrace_64.c               58             621          93.3
 arch/x86/kernel/ptrace_32.c               39             717          54.3

 [after]
 arch/x86/kernel/ptrace.c                  13            1135          11.4

so i'm not worried about that aspect. We are definitely "for the 
better".

	Ingo
