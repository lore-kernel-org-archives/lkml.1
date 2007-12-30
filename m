Return-Path: <linux-kernel-owner+w=401wt.eu-S1757138AbXL3Oxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138AbXL3Oxi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 09:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbXL3Oxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 09:53:31 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226AbXL3Oxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 09:53:30 -0500
Message-ID: <4777B0AA.9050503@redhat.com>
Date: Sun, 30 Dec 2007 09:52:26 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes remove fix_riprel #ifdef
References: <1198466917.6323.15.camel@brick> <47773CAD.7050907@redhat.com> <20071230132337.GF16946@elte.hu>
In-Reply-To: <20071230132337.GF16946@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Ingo Molnar wrote:
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>> Hello Harvey,
>>
>> A similar idea was already nack-ed by Ananth.
>> http://sources.redhat.com/ml/systemtap/2007-q4/msg00468.html
>> And I agree his thought.
>>
>> Especially, "riprel" does not exist on x86_32, so fix_riprel()
>> is meaningless on it.
>> Thus, I think it would better be ifdef'd in call-site.
> 
> but we regularly do this in generic code: we add calls that are NOPs on 
> some architectures. For example flush_cache_page() makes no sense on the 
> x86 architecture.

Indeed.
By the way, flush_cache_page() is defined as a do-while(0) on x86.
Would it better to define fix_riprel() as a do-while(0) on x86-32?
I think this obviously indicates that function has no effect.

> So i'm inclined to apply Harvey's cleanup - less
> #ifdef complexity in higher-level code is very much favored, even
> if "riprel" is a NOP concept on 32-bit.

OK, I agree about that fix_riprel() which is ifdef'd twice is too much ifdef'd.
Reducing ifdef is good to me.

Thanks,
> 
> 	Ingo

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

