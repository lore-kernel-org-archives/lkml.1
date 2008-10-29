Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbYJ2A4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbYJ2A4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 20:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYJ2A4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 20:56:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62949 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbYJ2A4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 20:56:00 -0400
Date: Tue, 28 Oct 2008 20:55:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: fix current_tracer error return
In-Reply-To: <c62985530810281734k578f1c2dka79ad045abb8bb93@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0810282052300.26466@gandalf.stny.rr.com>
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>  <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>  <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>  <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
  <alpine.DEB.1.10.0810281039130.29482@gandalf.stny.rr.com>  <c62985530810280835k66d3ab87qd1783a0135228174@mail.gmail.com>  <alpine.DEB.1.10.0810281140420.30971@gandalf.stny.rr.com>  <c62985530810281115n5e40539ek1a486a0b909e339c@mail.gmail.com> 
 <alpine.DEB.1.10.0810281429170.15590@gandalf.stny.rr.com> <c62985530810281734k578f1c2dka79ad045abb8bb93@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Oct 2008, Fr?d?ric Weisbecker wrote:
> >
> > My test scripts automatically set or unset /proc/sys/kernel/ftrace_enabled
> >
> > I believe I wanted that to be default off when dynamic ftrace was not
> > active. Currently, it really shouldn't matter, because there's a check to
> > make sure that ftrace has a registered function before calling it.
> >
> > That was just my preference. But if you find it less confusing, then
> > having ftrace_enabled as default on even when dynamic ftrace is not
> > enabled, is fine with me.
> >
> > -- Steve
> >
> >
> 
> Thanks. I guess this bug was there for several days. But since I

But this was not a bug :-/

I believe I purposely set it that way. The bug was that you did not know 
that you could enable it with /proc/sys/kernel/ftrace_enabled ;-)


> always used dynamic ftrace, I've not
> seen it until yesterday. (BTW I didn't tested with dynamic since this
> patch). I had one other bug that made the set of
> function tracer blocking during the write on current_trace with
> dynamic ftrace. I will have a look on it.

Hmm, that could be a bug, but I do not know the details.

> 
> Actually one thing that makes me a bit confused is the use of these
> two vars: ftrace_enabled and ftrace_disabled.
> They are not used for the same purpose but their name suggest the same
> role.... :-)

Well, the code documents it pretty well:

/* ftrace_enabled is a method to turn ftrace on or off */
int ftrace_enabled __read_mostly;
static int last_ftrace_enabled;

/*
 * ftrace_disabled is set when an anomaly is discovered.
 * ftrace_disabled is much stronger than ftrace_enabled.
 */
static int ftrace_disabled __read_mostly;

-- Steve

