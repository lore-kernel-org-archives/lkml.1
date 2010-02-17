Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0BQKmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 05:42:53 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:33958 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0BQKmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 05:42:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JU/FApJBf8kB2i31ChMKNK4aX7aVRt9w8IXwPiO5cbumCFA0mPjEFfs9+6DGWyle0O
         5FInBbWimlXtqCATE3Pg0ijGJcHvZs/Y0y/1O2j7Zc/CNaozToB00Eos8/fKu4Vq4tUb
         XPAFs0QPAHqHH2EdJKYCt0RvOXOUM2Acvz/Zs=
MIME-Version: 1.0
In-Reply-To: <20100216170540.GA28039@Krystal>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com>
	 <1266337450.24271.140.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain>
	 <20100216164744.GA25115@Krystal>
	 <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain>
	 <20100216170540.GA28039@Krystal>
Date: Wed, 17 Feb 2010 16:06:28 +0530
Message-ID: <f5a7b3811002170236i6c560eadp2de7deb10082db4f@mail.gmail.com>
Subject: Re: [ltt-dev] LTTng0.158 Linux-2629-RT kernel BUG: sleeping function 
	called from invalid context at kernel/rtmutex.c:685
From: naresh kamboju <naresh.kernel@gmail.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 16, 2010 at 10:35 PM, Mathieu Desnoyers
<compudj@krystal.dyndns.org> wrote:
> * Thomas Gleixner (tglx@linutronix.de) wrote:
>> On Tue, 16 Feb 2010, Mathieu Desnoyers wrote:
>> > > The function is called from an IPI. That's a LTTNG problem, not a RT one.

yes. it's seems be a LTTng0.158 problem.
I have tested with below combinations.

2.6.29                        ->no issues
2.6.29+LTTng0.100      ->no issues
2.6.29+LTTng0.158     ->no issues

2.6.29-RT                   ->no issues
2.6.29-RT+LTTng0.100 ->no issues
2.6.29-RT+LTTng0.158 ->BUG reported.

>> >
>> > I use del_timer in IPI to delete lttng per-cpu timers on all CPUs. I
>> > have to do this because timers created with add_timer_on are documented
>> > to be incompatible with del_timer_sync():
>> >
>> >  * Synchronization rules: Callers must prevent restarting of the timer,
>> >  * otherwise this function is meaningless. It must not be called from
>> >  * interrupt contexts. The caller must not hold locks which would prevent
>> >  * completion of the timer's handler. The timer's handler must not call
>> >  * add_timer_on(). Upon exit the timer is not queued and the handler is
>> >  * not running on any CPU.
>>
>> Errm. The documentation says:
>>
>>       "The timer's handler must not call add_timer_on()."
>>
>> It's not talking about a timer which was initialized with
>> add_timer_on().
>>
>>  And your per cpu timer handlers have no requirement to call
>> add_timer_on() simply because add/mod_timer() is requeueing the timer
>> on the same cpu on which the handler runs.
>>
>> So the IPI is just a solution for a non existing problem.
>
> Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
> saner del_timer_sync() scheme to delete the timers.

Could you give more info regarding, what kind of changes we can work on.
let me also work around on it.

Best regards,
Naresh Kamboju

>
> Thanks,
>
> Mathieu
>
>>
>> Thanks,
>>
>>       tglx
>>
>
> --
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
