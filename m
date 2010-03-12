Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab0CLXeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 18:34:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42586 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475Ab0CLXeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 18:34:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=8OTfl9jic9UA:10 a=ORa4HqFjfvEA:10 a=Q9fys5e9bTEA:10 a=fNZBj6YFGwC8gW0x7aEA:9 a=yyMLeY2KK0gipDPNFbYUR4_ApQkA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Using tracing_off() in __schedule_bug()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
References: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Mar 2010 18:34:04 -0500
Message-ID: <1268436844.4471.783.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 10:32 -0500, Chase Douglas wrote:
> We're considering using tracing_off() in __schedule_bug() in the
> Ubuntu kernel to help us solve "scheduling while atomic" bugs without
> needing to compile and install a special kernel to do so. Using the
> tracing_off() call enables us to generate smaller function traces when
> debugging, and find the bug easier since it should be at the end of
> any traces. The patch we are thinking of using can be found at [1].
> You can find an overview of how bugs are solved using this approach
> there as well.
> 
> Are there any thoughts as to the appropriateness of this patch in
> Ubuntu kernels? My guess is that this isn't done in the upstream
> vanilla kernels because it would be annoying to have a stock kernel
> littered with tracing_off() calls if you hit one when you weren't
> meaning to. However, we're interested in hearing if there's some
> negative consequence we haven't thought of.

Actually, it has been on my TODO list to litter tracing_off() all over
the kernel ;-)

No, by all means, I would definitely take a patch that turn off tracing
at critical areas. One of which I would like to do is with the BUG()
call.

Hmm, thinking about it more, I would rather have a separate function,
that would call tracing_off() if some variable is set. By default it
would be set, but in case you want to keep tracing after a bug is hit,
you can have a way to disable it.

I need to write up a patch soon. Thanks for bring this up.

-- Steve


