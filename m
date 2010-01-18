Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340Ab0ARRt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0ARRt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600Ab0ARRtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:49:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388Ab0ARRtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:49:55 -0500
Message-ID: <4B549F00.6060704@redhat.com>
Date: Mon, 18 Jan 2010 12:48:48 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer	operation
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B548A9A.1020806@redhat.com> <20100118172021.GL10364@nowhere>
In-Reply-To: <20100118172021.GL10364@nowhere>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Mon, Jan 18, 2010 at 11:21:46AM -0500, Masami Hiramatsu wrote:
>> Hmm, could you make it inline-functions or add __kprobes?
>> Because it is called from kprobes, we don't want to probe
>> the function which will be called from kprobes handlers itself.
>>
>> (IMHO, from the viewpoint of performance, inline-function
>>  could be better.)
>>
>> Thank you,
> 
> 
> 
> Yeah, may be inline ftrace_profile_buf_end, would be better.
> But we shouldn't inline ftrace_profile_buf_begin() I guess,
> considering its size.

Indeed, especially for events...

> While at it, may be let's choose more verbose names
> like
> 
> ftrace_profile_buf_fill() and ftrace_profile_buf_submit().
> 
> Also, profile is a bit of a misnomer. Not a problem since
> ftrace_profile_templ_##call() is already a misnomer, but
> we should start a bit of a rename. Sometimes, perf only
> profiles trace events as counters and sometimes it records
> the raw samples too.
> 
> So, as more generic names, I would suggest:
> 
> ftrace_perf_buf_fill() and ftrace_perf_buf_submit().


Actual filling buffer is done in the profile handlers,
so I think ftrace_perf_buf_prepare() may be better :-)
ftrace_perf_buf_submit is good to me:-)

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

