Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0BKVAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:00:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042Ab0BKVAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:00:15 -0500
Date: Thu, 11 Feb 2010 21:59:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100211205929.GA27038@redhat.com>
References: <20100210133556.GA21925@redhat.com> <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com> <20100211125607.GA5086@redhat.com> <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com> <20100211165059.GA16053@redhat.com> <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com> <20100211185530.GA22055@redhat.com> <4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com> <20100211201026.GA25172@redhat.com> <4352991a1002111239m681107f8g9e3802daf7ab706b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a1002111239m681107f8g9e3802daf7ab706b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Salman Qazi wrote:
>
> On Thu, Feb 11, 2010 at 12:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >>
> > Why? The tracee reports all signals. If the tracer does
> > ptrace(PTRACE_WHATEVER, SIGXXX) surely it knows SIGXXX is sent to
> > tracee.
>
> The ptrace syscall fails, as the child is running and so we are unable
> to restart the child.  I suppose it is not accurate to say "impossible
> to intercept" if it eventually works.  But, it's an unpleasant
> behaviour.  How do you distinguish between this race and the child
> suddenly becoming untraced or dying?

The child can't become untraced unless the tracer detaches. If the
tracee dies the tracer can notice this via wait(). And please note
again, this particular case is not possible when the tracee is
TASK_TRACED. The tracer explicitly instructed the tracee to stop in
TASK_STOPPED, it should take care of SIGCONT case.

But don't get me wrong, see below,

> > In any case. This is how ptrace currently works, there is no race
> > and the patch is not needed (in fact it is very wrong, but this
> > soesn't matter).
> >
> > Do you agree?
>
> I agree that the patch is wrong because of the reasons you mentioned
> earlier.  But I think there is an issue here.  It's hard to say what
> it is supposed to do, but I can certainly see it being more useful
> this behaviour wasn't there.

Ha. let me repeat, nobody thinks the current ptrace API is nice.


OK. Thanks Salman for your report and discussion.

Oleg.

