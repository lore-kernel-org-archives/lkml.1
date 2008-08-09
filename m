Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbYHIROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbYHIROS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYHIROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:14:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:12717 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYHIROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LmKw36Cd1+VK6B1Y/z8X8A03zyS+9lGaTthl5IS4FfIkwRJQRCWXr6ypRzZwBrEof4
         5YEbwJapV2t/mEmupIGZkaYSZdy8kHMsHNW+946BP+J0pWfUD324Pb3F318rP44AZTx1
         VYIJhWFKdeu/ENEmB2tGIGc6+4yOxYfrszUA0=
Message-ID: <863e9df20808091014w11896139q77850bc6eb7609b3@mail.gmail.com>
Date: Sat, 9 Aug 2008 22:44:01 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Roland McGrath" <roland@redhat.com>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       "Clark Williams" <williams@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0808091129460.25265@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080807182013.984175558@goodmis.org>
	 <863e9df20808090248h3adc2ac3mdb3217fe2876ab3b@mail.gmail.com>
	 <alpine.DEB.1.10.0808090854170.24140@gandalf.stny.rr.com>
	 <863e9df20808090801p7f9e11bar84d0e661440d591e@mail.gmail.com>
	 <alpine.DEB.1.10.0808091129460.25265@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2008 at 9:07 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> One of the things I tried to do was to make ftrace port easily to all
> archs. David Miller ported it to Sparc64 in 20 minutes and that was mostly
> compiling.  Doing a kprobe fix would require much more knowledge to each
> arch and more prone to errors.

I agree with the point about porting. My kprobe reference was simply
to point out that
an existing module seems to be overwriting code on the fly and doesn't
take care of much
on non-x86 archs. Ftrace has a unique 5-byte call replacement issue
specific to x86 which kprobes doesn't have to deal with.

>> This solution indeed would fit all archs well but for some it may be
>> an overkill (or is it?...I'd like to know that :-\ ).
>
> It is not an issue at all. The mcount list is discarded with the init
> section, and the change to nops is relatively fast. We do make a list of
> all entries anyway, so that we can pick and choose which functions we want
> to enable tracing on.

Ok.

> I want ftrace_record_ip to be as fast as possible, and also having it call
> the registered function means we need to test if it was set in the filter
> too. This is too much for what record_ip does. And as I said, doing it all
> on boot up would be best.

Alrighty.

Thanks,
Abhishek Sagar
