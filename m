Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0CMCul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 21:50:41 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55483 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab0CMCuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 21:50:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=h+ShRcFGh3U5kzkK5VX1heDfgxldbRZak2KL8nllmEaIhyN6VM0j2+MCeLWnNGw8Vk
         1ltCDiB9XODBINLD2LsVplfEH5zjpQxJtRcGuvNzcVjqeqVMbsEwAy2h36LNYRpzEaci
         QtWvdYs5VYFvBQ7+4UX9jzXjUMz/Bb69dqVtQ=
MIME-Version: 1.0
In-Reply-To: <1268447444.4471.789.camel@gandalf.stny.rr.com>
References: <40ec3ea41003120732w5f44a2ebq728047e742f32bba@mail.gmail.com>
	 <1268436844.4471.783.camel@gandalf.stny.rr.com>
	 <40ec3ea41003121812j7cb349e4g1c455ae096da35cd@mail.gmail.com>
	 <1268447444.4471.789.camel@gandalf.stny.rr.com>
Date: Fri, 12 Mar 2010 21:50:39 -0500
X-Google-Sender-Auth: e5c0be938e079070
Message-ID: <40ec3ea41003121850y44e08737mf0544c10f1193129@mail.gmail.com>
Subject: Re: Using tracing_off() in __schedule_bug()
From: Chase Douglas <chase.douglas@canonical.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 9:30 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-03-12 at 21:12 -0500, Chase Douglas wrote:
>> On Fri, Mar 12, 2010 at 6:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> > Hmm, thinking about it more, I would rather have a separate function,
>> > that would call tracing_off() if some variable is set. By default it
>> > would be set, but in case you want to keep tracing after a bug is hit,
>> > you can have a way to disable it.
>> >
>> > I need to write up a patch soon. Thanks for bring this up.
>>
>> I'd be happy to help out in this endeavor if you'd like. I'm wondering
>> if there shouldn't be multiple levels of tracing_off support specified
>> at boot time (disabled on WARNING, BUG, __schedule_bug, OOPS) in an
>> ordered priority way. I.e. tracing_off_bug would leave tracing on for
>> WARNING's, but turn it off for BUG's, schedule bugs, and oopses. The
>> default would be tracing_off_warn, which would call tracing_off on all
>> of the above.
>
> I think that's a bit over-engineering. I'd suggest that you either want
> to disable tracing on an error or you don't. I could add a tracing
> option that lets you stop it. Keep it simple. If it becomes complex, no
> one will use it.

I was thinking that there may be times where you want to skip warnings
to trace real bugs. For example, there's a WARNING that you hit if
your resume takes too long. I may want to skip that warning for the
oops that occurs just after it. As a distro, we also want to be
flexible in our official kernels so we don't have to build special
ones when people hit bugs. It's not as though it would be very
difficult to design with a few priorities, so unless it's really
unnecessary I don't see why we shouldn't. The default would also fire
tracing_off in all cases, so most people wouldn't have to modify it
unless they hit a corner case.

-- Chase
