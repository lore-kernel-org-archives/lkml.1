Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab0BKVFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:05:53 -0500
Received: from smtp-out.google.com ([216.239.44.51]:24554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab0BKVFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:05:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WaIE2he3ZUbwObaEEmiuhpZh2LDd0iWGauUvfeP+EXMIsD3eqTkn4XFRViyjSiES/
	gKUz6X+KD5Jv4VVEfWppg==
MIME-Version: 1.0
In-Reply-To: <20100211205558.B5BCB8163@magilla.sf.frob.com>
References: <20100208143231.6d804590.akpm@linux-foundation.org>
	 <20100211125607.GA5086@redhat.com>
	 <4352991a1002110832j1a4e6680scf4aa7effeb83a75@mail.gmail.com>
	 <20100211165059.GA16053@redhat.com>
	 <4352991a1002111043l35f1c1b5mcd9ad4c76f6351a7@mail.gmail.com>
	 <20100211185530.GA22055@redhat.com>
	 <4352991a1002111108n2be5f432i9484d2e8869daaa9@mail.gmail.com>
	 <20100211201026.GA25172@redhat.com>
	 <4352991a1002111239m681107f8g9e3802daf7ab706b@mail.gmail.com>
	 <20100211205558.B5BCB8163@magilla.sf.frob.com>
Date: Thu, 11 Feb 2010 13:05:48 -0800
Message-ID: <4352991a1002111305v5916460epf81464083d3245be@mail.gmail.com>
Subject: Re: Race in ptrace.
From: Salman Qazi <sqazi@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, taviso@google.com,
       Roland Dreier <rolandd@cisco.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 12:55 PM, Roland McGrath <roland@redhat.com> wrote:
>> What I don't agree with is that when we send SIGCONT later with
>> "kill", we wake up the child at all.  It may make sense to someone who
>> has access to the kernel source code, but from a user's point of view
>> this is a surprise.  The signal is intercepted and should not have an
>> effect on the child.
>
> This is the behavior of SIGCONT and doesn't really have anything to do with
> ptrace.  Once you have let the SIGSTOP through, the process is in job
> control stop just like if you'd sent a SIGSTOP without using ptrace at all.
>
> The distinction that is confusing you is that *generating* SIGCONT is what
> resumes the process, not *delivering* it.  Another example is that if your
> process has SIGCONT blocked or ignored, SIGCONT still wakes it up.  Another
> example is that SIGCONT wakes up all the threads in a process, before one
> of those threads delivers the SIGCONT (i.e. runs a handler).

Thanks for the clarification.  This is exactly the bit of information
I was missing.

>
>
> Thanks,
> Roland
>
