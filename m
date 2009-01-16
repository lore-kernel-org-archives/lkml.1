Return-Path: <linux-kernel-owner+w=401wt.eu-S936470AbZAPO3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936470AbZAPO3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935984AbZAPO2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:28:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936429AbZAPO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:28:38 -0500
Date: Fri, 16 Jan 2009 09:28:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/2] ftrace: add stack trace to function tracer
In-Reply-To: <c62985530901160208r4400e438j7c27528019c1a6db@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901160925480.22303@gandalf.stny.rr.com>
References: <20090116004050.273665842@goodmis.org>  <20090116004121.302184848@goodmis.org> <c62985530901160208r4400e438j7c27528019c1a6db@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 16 Jan 2009, Fr?d?ric Weisbecker wrote:

> Hi Steven,
> 
> 2009/1/16 Steven Rostedt <rostedt@goodmis.org>:
> > +static struct tracer_flags func_flags = {
> > +       .val = 0, /* By default: all flags disabled */
> > +       .opts = func_opts
> > +};
> > +
> > +static int func_set_flag(u32 old_flags, u32 bit, int set)
> > +{
> > +       if (bit == TRACE_FUNC_OPT_STACK) {
> > +               /* do nothing if already set */
> > +               if (!!set == !!(func_flags.val & TRACE_FUNC_OPT_STACK))
> > +                       return 0;
> 
> 
> This is just a small thing but set will always be 1 or 0. And if you want
> the current val of your options, you can take old_flags :-)

I never assume something is set to 0 or 1 ;-)

But I did overlook the "old_flags". Yeah that would be better to use.

> 
> Would you prefer I send a patch to not call the set_flag callback
> when the option set/unset by the user is already set/unset ?

Hmm, good question. That's the way I do it, but would that make sense fo
others?  Probably would be a good idea. We only want to know when the
flag changes.

-- Steve

