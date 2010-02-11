Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab0BKULN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:11:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798Ab0BKULM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:11:12 -0500
Date: Thu, 11 Feb 2010 21:10:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100211201026.GA25172@redhat.com>
References: <20100208143231.6d804590.akpm@linux-foundation.org> <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com> <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com> <20100211125607.GA5086@redhat.com> <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com> <20100211165059.GA16053@redhat.com> <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com> <20100211185530.GA22055@redhat.com> <4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Salman Qazi wrote:
>
> I understand what it does.  But, why is it the right thing to do?

Oh. Let's not discuss the current API. Nobody thinks it is great,
but we can't change it.

But,

> From the user's perspective, why should the task become untraced if we
> use ptrace to deliver the signal?

The task does not become untraced. The tracer (in your test-case)
explicitly asks the tracee to respect SIGSTOP and stop.

> Doesn't this make it impossible to
> intercept and control which signals are sent to a traced task?

Why? The tracee reports all signals. If the tracer does
ptrace(PTRACE_WHATEVER, SIGXXX) surely it knows SIGXXX is sent to
tracee.




In any case. This is how ptrace currently works, there is no race
and the patch is not needed (in fact it is very wrong, but this
soesn't matter).

Do you agree?

Oleg.

