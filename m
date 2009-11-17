Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbZKQPYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbZKQPYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbZKQPYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZKQPYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:24:37 -0500
Message-ID: <4B02C0A6.9030605@redhat.com>
Date: Tue, 17 Nov 2009 10:26:30 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Roland McGrath <roland@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 3/3] Add get_signal tracepoint
References: <20091113225226.15079.90813.stgit@harusame>  <20091113225240.15079.4863.stgit@harusame>  <20091113235333.0E3CC15E8@magilla.sf.frob.com>  <20091114001020.GB24738@elte.hu>  <4B01C95B.1070302@redhat.com> <20091117060130.GB30852@elte.hu>
In-Reply-To: <20091117060130.GB30852@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
>>>  - signal IPI/wakeup events
>>
>> All signals might be used for IPI, isn't it? :-)
> 
> I mean, to analyze the various dynamic delivery details of how a signal 
> send affects a target task:
> 
>  1) which task/PID was selected to be woken
> 
>  2) if the task got woken (from sleep) due to the signal sending
> 
>  3) if it was already woken, whether it needed an IPI via kick_process()

Hmm, as far as I can see, some of these events can be caught by
sched layer too.
- trace_signal_send() will record target task.
- wake_up_state() just calls try_to_wake_up(), and trace_sched_wakeup()
  will be called from it.
- kick_process() might better have its own tracepoint.

And also, I think signal_wake_up() might not be a good tracepoint for
signal event, since there is no signr. Moreover some signal_wake_up()
caller(e.g. recalc_sigpending*) silently wake up processes :-(.

> What proportion of signals were wakeups and what proportion hit an 
> already running task is a relevant question to ask when analyzing the 
> performance characteristics of signals.

Hmm, does it really require wakeup events in signal layer?
I think that we can analyze the characteristics by combination
of signal events and sched events.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

