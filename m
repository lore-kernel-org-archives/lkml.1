Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbZA2O31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbZA2O31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 09:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZA2O3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 09:29:19 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:65051 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZA2O3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 09:29:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DpwmUY7RTD+gZ6NhTXl4aZNc5PqKBdPS8QJj1+jxTPlHDSjlCmRoFdoxpRbCTkl9qz
         XLclMy6TFpSLIL3JlFKC9voyis8euc7l1XPrDR0Y1KF+0sfSjTPePvOWsZbs2KxPNfY2
         C4YrgzZ5AvRTh83xJlpwST/XDgmCOAodcapns=
MIME-Version: 1.0
In-Reply-To: <20090129140451.GM24391@elte.hu>
References: <497F69A4.2070007@intel.com> <20090127224303.GB5850@nowhere>
	 <20090127225048.GA4652@nowhere> <20090129140451.GM24391@elte.hu>
Date: Thu, 29 Jan 2009 15:29:15 +0100
Message-ID: <c62985530901290629i168ac12cjc4b22140caceff58@mail.gmail.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, srostedt@redhat.com,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>, utrace-devel@redhat.com,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/29 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> On Tue, Jan 27, 2009 at 11:43:03PM +0100, Frederic Weisbecker wrote:
>> > On Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke wrote:
>> > >
>> > > This tracer monitors regular file open() syscalls. This is a fast
>> > > and low-overhead alternative to strace, and does not allow or
>> > > require to be attached to every process.
>> > >
>> > > The tracer only logs succesfull calls, as those are the only ones we
>> > > are currently interested in, and we can determine the absolute path
>> > > of these files as we log.
>> > >
>> > > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
>> >
>> >
>> > Hi Auke,
>> >
>> > Speaking about a global syscall tracer, I made a patch to trace only the syscalls
>> > with the function-graph-tracer.
>> >
>> > http://lkml.org/lkml/2008/12/30/267
>> >
>> > Its approach and purpose is different than a tracer dedicated only to syscalls.
>> > The function graph tracer traces execution graph of the functions and is more about
>> > execution time spent and code flow whereas a syscall tracer can provide more specific
>> > informations about syscalls.
>> >
>> > So both are not overlaping.
>> >
>> > But the low level part of my patch creates a thread flag _TIF_SYSCALL_TRACE which triggers
>>
>> s/_TIF_SYSCALL_TRACE/_TIF_SYSCALL_FTRACE
>
>> > Once we have it, I think a syscall tracer can be fed with new syscalls
>> > events through several patch iterations, starting with the open and
>> > close one :-)
>> >
>> > Are you ok with that?
>> >
>> > Steven, Ingo, do you agree?
>
> yes. We definitely need this on the asm syscall level, to not contaminate
> hundreds of syscalls with tracepoints.
>
> Auke's sys_open() plugin would be a nice prototype for that concept - but
> in generally it would be useful to be able to augment kernel tracer output
> with all syscall events that occur.
>
> The output would be something like a slimmed-down strace, but for the
> whole kernel and not tied to ptrace semantics (which are crippling).
>
> Would you be interested in extending your syscall tracing concept with
> those bits and would you be interested in integrating Auke's plugin into
> that
>
>        Ingo


Several people talked me about utrace and gave some examples about it
in this discussion.
The Api is very convenient to fetch syscall numbers, arguments and
return values.
And the hooks are done in the generic core code, so it is arch independent.

The only drawback I can see is that it is not yet merged upstream, in
need of in-kernel users.
If it only depends on this condition, we could be these users...

What do you think?
