Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZIAXWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZIAXWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZIAXWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:22:23 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57979 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbZIAXWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:22:22 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, arjan@infradead.org, jeremy@goop.org,
       mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tj@kernel.org, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-tip-commits@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 0/1] kthreads: simplify !kthreadd_task logic, kill kthreadd_task_init_done
References: <20090829182718.10f566b1@leela>
	<tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org>
	<20090901100351.GA3361@elte.hu> <20090901113914.GA23578@elte.hu>
	<20090901130436.GA22514@redhat.com> <20090901131440.GA29783@elte.hu>
	<20090901133709.GA24041@redhat.com> <20090901135925.GA9083@elte.hu>
	<20090901145526.GA31317@redhat.com> <20090901165235.GA9105@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 01 Sep 2009 16:22:11 -0700
In-Reply-To: <20090901165235.GA9105@redhat.com> (Oleg Nesterov's message of "Tue\, 1 Sep 2009 18\:52\:35 +0200")
Message-ID: <m13a76xnbw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, rusty@rustcorp.com.au, linux-tip-commits@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, tglx@linutronix.de, tj@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, mschmidt@redhat.com, jeremy@goop.org, arjan@infradead.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 09/01, Oleg Nesterov wrote:
>>
>> On 09/01, Ingo Molnar wrote:
>> >
>> > * Oleg Nesterov <oleg@redhat.com> wrote:
>> >
>> > > On 09/01, Ingo Molnar wrote:
>> > > >
>> > > > * Oleg Nesterov <oleg@redhat.com> wrote:
>> > > >
>> > > > > Yes, this should work. But I _think_ we can make the better fix...
>> > > > >
>> > > > > I'll try to make the patch soon. Afaics we don't need
>> > > > > kthreadd_task_init_done.
>> > > >
>> > > > ok.
>> > >
>> > > Just in case, the patch is ready. [...]
>> >
>> > yes - that's roughly the cleanup i referred to in the commit log.
>> >
>> > way too late for -rc8 though - the minimal fix i did _might_ be
>> > eligible.
>> >
>> > agreed?
>>
>> Agreed. Then I will sent the patch on top of this change.
>
> OK, I am sending the patch on top of your fix. Not sure how to really
> test it, but at least the kernel works when I apply the debugging patch
> below on top.

Stupid question.  How is it that we wind up trying to start kernel threads
before it is safe to do so?

Races should be impossible because the scheduler isn't running until a few
lines later.

Eric
