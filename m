Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0BKUjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:39:18 -0500
Received: from smtp-out.google.com ([216.239.44.51]:14367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab0BKUjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:39:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Uw+aX7D8f9+4bJd/dr9CfN5PyJdyoLiGiK/AUdKmKK353DocD1FW8q9Q+R6hQ2CmH
	/WJp+7W2Xx5sWAjomOH5Q==
MIME-Version: 1.0
In-Reply-To: <20100211201026.GA25172@redhat.com>
References: <20100208143231.6d804590.akpm@linux-foundation.org>
	 <20100210133556.GA21925@redhat.com>
	 <4352991a1002101038s6a2e67d9mc373416c17de9e6a@mail.gmail.com>
	 <20100211125607.GA5086@redhat.com>
	 <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
	 <20100211165059.GA16053@redhat.com>
	 <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
	 <20100211185530.GA22055@redhat.com>
	 <4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com>
	 <20100211201026.GA25172@redhat.com>
Date: Thu, 11 Feb 2010 12:39:09 -0800
Message-ID: <4352991a1002111239m681107f8g9e3802daf7ab706b@mail.gmail.com>
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

On Thu, Feb 11, 2010 at 12:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/11, Salman Qazi wrote:
>>
>> I understand what it does.  But, why is it the right thing to do?
>
> Oh. Let's not discuss the current API. Nobody thinks it is great,
> but we can't change it.
>
> But,
>
>> From the user's perspective, why should the task become untraced if we
>> use ptrace to deliver the signal?
>
> The task does not become untraced. The tracer (in your test-case)
> explicitly asks the tracee to respect SIGSTOP and stop.
>
>> Doesn't this make it impossible to
>> intercept and control which signals are sent to a traced task?
>
> Why? The tracee reports all signals. If the tracer does
> ptrace(PTRACE_WHATEVER, SIGXXX) surely it knows SIGXXX is sent to
> tracee.
>
>

The ptrace syscall fails, as the child is running and so we are unable
to restart the child.  I suppose it is not accurate to say "impossible
to intercept" if it eventually works.  But, it's an unpleasant
behaviour.  How do you distinguish between this race and the child
suddenly becoming untraced or dying?

What I don't agree with is that when we send SIGCONT later with
"kill", we wake up the child at all.  It may make sense to someone who
has access to the kernel source code, but from a user's point of view
this is a surprise.  The signal is intercepted and should not have an
effect on the child.

>
>
> In any case. This is how ptrace currently works, there is no race
> and the patch is not needed (in fact it is very wrong, but this
> soesn't matter).
>
> Do you agree?

I agree that the patch is wrong because of the reasons you mentioned
earlier.  But I think there is an issue here.  It's hard to say what
it is supposed to do, but I can certainly see it being more useful
this behaviour wasn't there.  Thanks for your time and attention on
this matter.

>
> Oleg.
>
>
