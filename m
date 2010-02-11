Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0BKS5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 13:57:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0BKS53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:57:29 -0500
Date: Thu, 11 Feb 2010 19:55:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Salman Qazi <sqazi@google.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Race in ptrace.
Message-ID: <20100211185530.GA22055@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com> <20100208143231.6d804590.akpm@linux-foundation.org> <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com> <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com> <20100211125607.GA5086@redhat.com> <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com> <20100211165059.GA16053@redhat.com> <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11, Salman Qazi wrote:
>
> >> >                // the tracee is STOPPED as requested, not TRACED,
> >> >                // SIGCONT wakes it up
> >> >                kill(pid, SIGCONT);
>
> I am still missing something.  There's probably a gap in my
> understanding, so let's try to clarify it.  The last "kill" call,
> sends a SIGCONT.  But, shouldn't this SIGCONT be intercepted by the
> tracer before the tracee sees it?

No. The tracee resumes (again: because it was STOPPED, not TRACED),
dequeues SIGCONT, reports the signal and stops in TASK_TRACED,
see ptrace_signal(). Meanwhile, until it calls ptrace_stop(), it is
TASK_RUNNING and ptrace() fails.

Oleg.

