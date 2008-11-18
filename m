Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYKRQbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYKRQbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYKRQbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:31:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:29343 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYKRQbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:31:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nVBkcVX9ViZso7KOXH5UnjxErpEy2l8rlzIfCgMmFHj4aiFNE4kmR3pMjpk9Jr2gCw
         nne23Rm1YVsHdw8j2egIJWjqHDR9jfVzYCv/+g6EfpJmvzxsNj+mcjL5yayWCsbQ5Bj1
         Naku3AjPK/fWjxNPiBNb/TuKWD73v9NdUDwRk=
Message-ID: <c62985530811180831n132ed6dep77aa2684ff59861@mail.gmail.com>
Date: Tue, 18 Nov 2008 17:31:37 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 3/3] tracing/function-return-tracer: add the overrun field
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081118155045.GJ30358@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4920D571.4050007@gmail.com> <20081117084923.GD28786@elte.hu>
	 <4921BA25.3090704@gmail.com> <20081118084755.GK17838@elte.hu>
	 <alpine.DEB.1.10.0811180922370.15003@gandalf.stny.rr.com>
	 <20081118145154.GC30358@elte.hu>
	 <alpine.DEB.1.10.0811181006010.15003@gandalf.stny.rr.com>
	 <20081118151326.GH30358@elte.hu>
	 <alpine.DEB.1.10.0811181020350.15003@gandalf.stny.rr.com>
	 <20081118155045.GJ30358@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/18 Ingo Molnar <mingo@elte.hu>:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>>
>> On Tue, 18 Nov 2008, Ingo Molnar wrote:
>> > > >
>> > > > that reminds me: ti->ret_stack[] should be moved to task->ret_stack[].
>> > > > That way we decouple its size from any kernel stack size limits.
>> > > > (thread-info resides at one end of the kernel stack, on x86)
>> > >
>> > > Yeah, I recommended that to Frederic to save space. But that can be
>> > > dangerous. Using task instead would be safer with the downside of
>> > > making the task struct even bigger.
>> >
>> > We almost never put new stuff into thread_info - we have the
>> > lockdep lock stack in the task structure too, for similar reasons.
>>
>> Yeah, it was just a recommendation, and perhaps not a good one ;-)
>>
>> Frederic, it is better if you move the array from the thread info to
>> the task struct. It will take up more memory but it is a hell of a
>> lot safer. The pro here definitely outways the con.
>
> if the memory footprint starts mattering we could turn this into a
> single pointer to an array - and add/remove these arrays (from all
> tasks currently running) as the tracer is turned on/off.
>
>        Ingo
>

Ok. So what do you suggest once? Do I begin to move the array from
thread info to struct task but by keeping the static
array or should I directly use a dynamic allocation and add/remove dynamically?
