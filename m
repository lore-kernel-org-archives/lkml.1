Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYJXP1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYJXP1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 11:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYJXP0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 11:26:55 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:46730 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYJXP0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 11:26:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ixLgmfK4a3RXzIB0TicIfsk5BfB5IuDBuBRzuedv2o4biuNkBBL1oh8aiREoBaHnHw
         QizhIG7dLGEFaOBbu/M1H4tJVdgAn1Szupcr/DKrm0JFQ0OelNHRvmrWFd3QbqXf1dfA
         gYnt+d/+o0AHCUoGBPi7ooUy5UrKFwe1uF2XA=
Message-ID: <c62985530810240826l2e025e94i51fdfd0fc70b0449@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:26:53 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
In-Reply-To: <20081024150239.GB20768@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F10B0B.406@gmail.com>
	 <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
	 <y0mmygv18le.fsf@ton.toronto.redhat.com>
	 <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com>
	 <20081024143744.GA20768@redhat.com>
	 <alpine.DEB.1.10.0810241046300.3882@gandalf.stny.rr.com>
	 <20081024150239.GB20768@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/24 Frank Ch. Eigler <fche@redhat.com>:
> That's what we do with the systemtap script, where kernel "handling"
> consists of "running the machine code".
>
>> But have the user application interface be very simple, and perhaps
>> even use perl or python.
>
> perl and python are pretty big procedural languages, and are not
> easily compiled down to compact & quickly executed machine code.  (I
> take it no one is suggesting including a perl or python VM in the
> kernel.)  Plus, debugger-flavoured event-handling programming style
> would not look nearly as compact in perl/python as in systemtap, which
> is small and domain-specific.
>
> - FChE
>

Actually what I thought is a style like this (Python like):

probe = Systemtap.probeFunc("lock_kernel")
probe.captureUtime("utime"))
probe.captureBacktrace("trace")
probe.trace()

For an obvious set of batch work like that, that could be possible,
perhaps even easy
to implement an Api...
When the object calls trace(), the userspace Systemtap analyse the list
of work to do and then translate into commands in kernel space.

And the script could wait for events and then do its own processing
with the captured events
(do some operations on delays, on output....).

for event in probe.getEvent(): #blocking
    print event["utime"]
    trace = event["trace"] #Systemtap.trace object with specific
fields and a default string repr
    print trace

It would be interpreted by Python itself, and you just have to capture
commands and works
sent through Api. Then, when the kernel has something to give, you
just have to place it in the
appripriate object and transmit it to the script which is waiting.
Processing and output with the data are done by the python script.
So actually, the python script only needs to ask you what data to
capture. It's its own responsability to
do wathever it wants with.

What do you think?
