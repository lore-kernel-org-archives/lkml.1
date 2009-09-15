Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbZIOJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbZIOJBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbZIOJBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:01:15 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:64952 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbZIOJBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:01:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d2wMQlUBNk0V47rFOguxuIiLMd3fqMviLi5iRCqJTeO9DrqD1LsiX4XLJ7+dRv16Ne
         M0Z0nGEGXEi4Vw/Fe9VsAzDREhXVnw2sU9IgY2v5oOtOoOXcyEA15IeepPuXR44BgFSS
         wytWssHWkjdEsZdCGICFGhGLUPMF850KMCLMM=
MIME-Version: 1.0
In-Reply-To: <1252998994.5506.0.camel@laptop>
References: <20090804161640.70817ee6.sfr@canb.auug.org.au>
	 <20090912073906.GA3972@elte.hu> <1252753957.12217.10.camel@ht.satnam>
	 <1252941416.2964.143.camel@localhost.localdomain>
	 <70318cbf0909141009v46581785m4c70edf31fcb79fa@mail.gmail.com>
	 <1252952238.2964.154.camel@localhost.localdomain>
	 <1252952621.31964.0.camel@twins>
	 <1252953076.2964.156.camel@localhost.localdomain>
	 <20090914184123.GC6045@nowhere> <1252998994.5506.0.camel@laptop>
Date: Tue, 15 Sep 2009 11:01:15 +0200
Message-ID: <c62985530909150201p3d5ca037g232c9456e6436fc@mail.gmail.com>
Subject: Re: Warning from ring buffer code (Was: Re: linux-next: tip tree 
	build warning)
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Christopher Li <sparse@chrisli.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-sparse@vger.kernel.org, Josh Triplett <josh@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/15, Peter Zijlstra <peterz@infradead.org>:
> On Mon, 2009-09-14 at 20:41 +0200, Frederic Weisbecker wrote:
>> On Mon, Sep 14, 2009 at 02:31:16PM -0400, Steven Rostedt wrote:
>> > On Mon, 2009-09-14 at 20:23 +0200, Peter Zijlstra wrote:
>> > > On Mon, 2009-09-14 at 14:17 -0400, Steven Rostedt wrote:
>> > > > Frederic, how big can one of those events get. The ring buffer (and
>> > > > TRACE_EVENT) allow up to almost a page size, which is very hefty for
>> > > > the
>> > > > stack. This code needs to either be rewritten or we need to set a
>> > > > limit
>> > > > to the size of a profile entry.
>> > >
>> > > Yeah, that needs to get a re-write.. I've complained about this when
>> > > it
>> > > went in.
>> >
>> > One answer is to create a per cpu buffer that is big enough to hold the
>> > data needed. Then you can disable interrupts an use it without worry.
>> >
>> > If you need to also handle NMIs, then create a per_cpu NMI buffer too,
>> > and use that if "in_nmi()" is true.
>> >
>> > -- Steve
>>
>>
>> Looks like a nice idea.
>>
>> Peter, does that sound acceptable to you to disable interrupts during a
>> profiled tracepoint event?
>
> It does anyway, a little further down the line, so sure.


Ok I'll fix it soon using Steve's idea then.

Thanks.
