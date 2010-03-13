Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0CMCas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:30:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46547 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab0CMCar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:30:47 -0500
X-Authority-Analysis: v=1.0 c=1 a=8OTfl9jic9UA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lv2ZgClW7LWqcdrlDAcA:9 a=y09ZD6wMTvxKSuaELE8pV8NWK_QA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: Using tracing_off() in __schedule_bug()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
In-Reply-To: <40ec3ea41003121812j7cb349e4g1c455ae096da35cd@mail.gmail.com>
References: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
	 <1268436844.4471.783.camel@gandalf.stny.rr.com>
	 <40ec3ea41003121812j7cb349e4g1c455ae096da35cd@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Mar 2010 21:30:44 -0500
Message-ID: <1268447444.4471.789.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 21:12 -0500, Chase Douglas wrote:
> On Fri, Mar 12, 2010 at 6:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:

> > Hmm, thinking about it more, I would rather have a separate function,
> > that would call tracing_off() if some variable is set. By default it
> > would be set, but in case you want to keep tracing after a bug is hit,
> > you can have a way to disable it.
> >
> > I need to write up a patch soon. Thanks for bring this up.
> 
> I'd be happy to help out in this endeavor if you'd like. I'm wondering
> if there shouldn't be multiple levels of tracing_off support specified
> at boot time (disabled on WARNING, BUG, __schedule_bug, OOPS) in an
> ordered priority way. I.e. tracing_off_bug would leave tracing on for
> WARNING's, but turn it off for BUG's, schedule bugs, and oopses. The
> default would be tracing_off_warn, which would call tracing_off on all
> of the above.

I think that's a bit over-engineering. I'd suggest that you either want
to disable tracing on an error or you don't. I could add a tracing
option that lets you stop it. Keep it simple. If it becomes complex, no
one will use it.

-- Steve


