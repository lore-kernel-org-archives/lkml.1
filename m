Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0CHCbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 21:31:44 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:64863 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab0CHCbh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 21:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nBlWM0WVQQu+8efzgjPhqXHIv7NAfErSRPOh69NAE0al/vbt0E6+P/s//z7emdmmb2
         UsLrxPLDJb/uzvg6JYVL9tiBjZfo292aOyjgjnRUb+gded+uhtrDDxYDMqEnSEabACz6
         xT9iVaxCxIChDZcn8PKgOmrdSKDDYkCAuMlMg=
MIME-Version: 1.0
In-Reply-To: <1267801603.10871.1725.camel@gandalf.stny.rr.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
Date: Mon, 8 Mar 2010 10:31:36 +0800
Message-ID: <2375c9f91003071831x4104dd8dp82967c0409391bd5@mail.gmail.com>
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: rostedt@goodmis.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 11:06 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-03-05 at 15:16 +0800, Américo Wang wrote:
>> On Fri, Mar 5, 2010 at 12:14 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> > On Thu, Mar 4, 2010 at 9:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >> On Wed, 2010-03-03 at 14:04 +0800, Américo Wang wrote:
>> >>> I am not sure if this is ftrace's fault, but it is ftrace who triggers
>> >>> the soft lockup. On my machine, it is pretty easy, just run:
>> >>>
>> >>> echo function_graph > current_tracer
>> >>>
>
>> >
>> > I can't say that because I didn't try -rc6.
>> >
>>
>> Sigh, 2.6.33-rc6 doesn't work, even 2.6.32 doesn't work...
>
> So basically you are saying that the function_graph tracer, when enabled
> has a high overhead? Well, unfortunately, that's expected.


A unusable system is expected? ;-)
Here my machine is too slow to use.

>
> So my question to you is, have you seen the function graph perform
> better with the same configs in previous kernels? Also, the function
> graph makes other debugging (like lockdep) have a greater impact to
> performance than they usually do.


Oh, sorry, I still don't find a working kernel, I will try today.

>
> Now some things you can do to help performance. One is not to trace
> functions that are known to have a high hit rate. You can do this with
> the set_ftrace_notrace file, or add "ftrace_notrace=func1,func2,func3"
> to the command line where func1,func2,func3 are the functions you do not
> want to trace. This just adds these by default to the set_ftrace_notrace
> and can be removed at runtime.
>
>
> The functions I commonly write to are:
>
> echo '*spin_lock*' '*spin_unlock*' '*spin_try*' '*rcu_read*' > set_ftace_notrace
>
> since these functions are hit quite intensively, by not tracing them it
> helps a bit with performance.

I will try this now.

Thanks!
