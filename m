Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751164Ab0CDFK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 00:10:26 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:36840 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0CDFKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 00:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I1H1k13fCtvBWMw+CXx/bFuYPZiiOVfgFaqwXq0qCrSbU5HzbzAlW77R3vmZAqDfyl
         Azrc8Ges8kddm5rwlPO5/6UTdhLthC4D89mlZ52q8TJtGMKT+0/fk6LWBzUnz5kkyt1Q
         pLp53DIX05zCwUAJSgtD2D0fR/+ai8EAz6ZSs=
MIME-Version: 1.0
In-Reply-To: <1267672706.10871.97.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <20100304014641.GH5194@nowhere>
	 <2375c9f91003031901v19c00c21k4a5d46bbe9ade3f@mail.gmail.com>
	 <1267672706.10871.97.camel@gandalf.stny.rr.com>
Date: Thu, 4 Mar 2010 13:10:16 +0800
Message-ID: <2375c9f91003032110n3a7f0e94v1ecf9e2535795b62@mail.gmail.com>
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: rostedt@goodmis.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 11:18 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2010-03-04 at 11:01 +0800, Américo Wang wrote:
>
>> >
>> > So it is stuck in stop machine. I wonder where exactly. I see some do_exit
>> > at the top but I wonder how much they are reliable.
>>
>> Well, I think 'kstop' is just random, sometimes I got 'watchdog' or some other
>> process.
>>
>> >
>> > Anyway, as Steve said, we really need a full config to reproduce it.
>> >
>>
>> Done in another reply.
>
> Thanks!
>
> Frederic, I notice that lockdep is on, did anything change that might
> slow down the code in lockdep, or is the function graph tracer doing
> more locking?
>
> I'm betting that we are hitting a live lock. That is, an interrupt goes
> off, it is being traced, and the function graph is tracing it, but some
> locking is happening (although it also tracks disabling of interrupts)
> and this slows the interrupt handler down enough that when it finishes,
> another interrupt goes off.
>
> Américo,
>
> Could you disable LOCKDEP and see if you still encounter this lockup?
>

Sure, after disabling LOCKDEP, I can't see the warning, _but_ the system
is still as unacceptablly slow as when LOCKDEP was enabled.

So I am afraid the problem is still there.

Thanks.
