Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752712AbYLRVHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbYLRVHk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbYLRVHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:07:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:40651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYLRVH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:07:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jpBgf4XQ+ZrEw0XgZlLhVmWaY6/+CqPcqpoEHTYqzGmlRM8nFwTkNsgBCrBhWNsOtp
         /geg2j9hQpSAwPpVs27LklA4CwGF42DDCOBp+JpsPc5hjZ2AE3CGH3s0QAIyRT2O8zsf
         jpLYzG03GNoNoIFulPPMHC8oPgjwIeVQgHDNc=
Message-ID: <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
Date: Thu, 18 Dec 2008 22:07:27 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081218112216.GE14332@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
	 <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
	 <20081218112216.GE14332@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/18 Ingo Molnar <mingo@elte.hu>:
> i meant that abstractly. The "solution" here is that your patch turns off
> the function-graph-tracer. The practical effect of that is: the system
> gets much faster at processing hrtimer IRQs and effectively "speeds up".
>
> ok?
>
>        Ingo
>

Ok :-)

> that would be important to double-check. Frederic, does the system lock up
> with a periodic 1khz HZ tick just as much? I.e. does the processing of a
> single timer interrupt take more than 1 milliseconds?
>
> Granted, if the system is too slow to process the system clock, it's not
> useful.
>
> But that's my point: instead of just randomly disabling functionality
> until the system gets 'fast enough' to process timer IRQs, how about
> dynamically and adaptively extending the required minimal timeout between
> hr-timer IRQs?
>
> That will in essence self-tune the system into some minimally working
> state - instead of locking it up. Note that such a method would work with
> any source of timer IRQ slowness - not just tracing.
>
> ( And maybe the lockup is somehow hrtimer IRQ induced. If a 1khz clock
>  still works for Frederic then that angle has to be investigated. )
>
>        Ingo
>

Hmm. No, I just tested by setting 1000 HZ and disabled NOHZ, the
system doesn't lockup unless I turn on the
function graph tracer.
That's strange.
Perhaps I should look at the time elapsed between two retries on
hrtimer_interrupts because it takes almost more than one
second to disable tracing after I enabled it (that really too much for
10 interations inside hrtimer_interrupt, even with
the time of tracing process).
