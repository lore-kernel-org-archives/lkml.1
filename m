Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbYA0WKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbYA0WKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYA0WJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:09:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbYA0WJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:09:52 -0500
Message-ID: <479D00EC.20600@redhat.com>
Date: Sun, 27 Jan 2008 17:08:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Abhishek Sagar <sagar.abhishek@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] x86: WARN_ON breakpoints from .kprobes.text section
References: <479C4A4F.10604@gmail.com> <479C94F6.2070502@redhat.com> <863e9df20801270733n4b82b595u8421fb07c18acaa6@mail.gmail.com>
In-Reply-To: <863e9df20801270733n4b82b595u8421fb07c18acaa6@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abhishek,

Abhishek Sagar wrote:
> On 1/27/08, Masami Hiramatsu <mhiramat@redhat.com> wrote:
>> Sorry, I can not understand what issue these patches can solve.
>> The breakpoint which is inserted by external debugger will be checked by
>> kprobe_handler() and be passed to other exception_notify_handlers.
>> In that case, we don't need to warn it.
>> I think current code is enough simple.
> 
> kprobe_handler has a blanket check for all non-kprobe breakpoints.
> They're all left to the kernel to handle. This is fine. Although
> external debuggers are free to plant breakpoints anywhere, they should
> be discouraged from doing so inside .kprobes.text region. Placing them
> there may lead to recursive page-fault/trap handling. It's a defensive
> check. I hope I've been able to clarify.

Thank you for explanation, I hope I can understand it.
Even if it causes a trap recursively, it could be checked (and ignored) by
longjump_break_handler(), and passed to the debugger correctly.
Please consider that someone expands jprobe(jprobe2) which uses
jprobe_return2() instead of jprobe_return(), how would you handle it?
Current kprobes provides an opportunity to those external probe frameworks
for checking it by themselves.

By the way, external kernel debugger knows how kprobes (and exception notifier)
works, so I think it can fetch his exception before kprobes does (by tweaking
notifier chain, etc).
(I hope all external kernel debuggers take care of it. :-))

Thank you again,

> 
> Thanks,
> Abhishek Sagar

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

