Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0BKTIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:08:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28318 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab0BKTI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:08:29 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=tfLlyj59fUufwDXaqWW3wVlp2pWpZL2nwX3dToKCeJgdDFqP5WPwE5bxhwUwkHlPr
	91fdi1lhff+D2V59jup0g==
MIME-Version: 1.0
In-Reply-To: <20100211185530.GA22055@redhat.com>
References: <20100208221632.A7D6F9B33B@bumblebee1.mtv.corp.google.com>
	 <20100208143231.6d804590.akpm@linux-foundation.org>
	 <20100209112700.GA4258@redhat.com> <20100210133556.GA21925@redhat.com>
	 <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
	 <20100211125607.GA5086@redhat.com>
	 <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
	 <20100211165059.GA16053@redhat.com>
	 <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
	 <20100211185530.GA22055@redhat.com>
Date: Thu, 11 Feb 2010 11:08:24 -0800
Message-ID: <4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com>
Subject: Re: Race in ptrace.
From: Salman Qazi <sqazi@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: taviso@google.com, Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I understand what it does.  But, why is it the right thing to do?
>From the user's perspective, why should the task become untraced if we
use ptrace to deliver the signal?  Doesn't this make it impossible to
intercept and control which signals are sent to a traced task?

On Thu, Feb 11, 2010 at 10:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/11, Salman Qazi wrote:
>>
>> >> >                // the tracee is STOPPED as requested, not TRACED,
>> >> >                // SIGCONT wakes it up
>> >> >                kill(pid, SIGCONT);
>>
>> I am still missing something.  There's probably a gap in my
>> understanding, so let's try to clarify it.  The last "kill" call,
>> sends a SIGCONT.  But, shouldn't this SIGCONT be intercepted by the
>> tracer before the tracee sees it?
>
> No. The tracee resumes (again: because it was STOPPED, not TRACED),
> dequeues SIGCONT, reports the signal and stops in TASK_TRACED,
> see ptrace_signal(). Meanwhile, until it calls ptrace_stop(), it is
> TASK_RUNNING and ptrace() fails.
>
> Oleg.
>
>
