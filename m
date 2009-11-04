Return-Path: <linux-kernel-owner+w=401wt.eu-S1756375AbZKDOMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375AbZKDOMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbZKDOMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:12:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755346AbZKDOMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:12:23 -0500
Message-ID: <4AF18B95.3070205@redhat.com>
Date: Wed, 04 Nov 2009 09:11:33 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 0/5] perf-probe and kprobe-tracer	updates
References: <20091104001204.3454.75999.stgit@harusame> <20091104021532.GC5092@nowhere>
In-Reply-To: <20091104021532.GC5092@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Tue, Nov 03, 2009 at 07:12:04PM -0500, Masami Hiramatsu wrote:
>> BTW, I think perf-probe and kprobe-event might better share
>> similar syntax for not confusing users. And for that purpose,
>> perf-probe syntax should introduce event/group specifier,
>> for example,
>
>
> I personally more imagine the debugfs kprobe-event interface as
> something used by higher level applications rather than users.
>
> I've tried to use kprobe events directly by the past to do
> some debugging, and once I wanted to go further a simple function
> probe, like fetching a variable or putting a probe in a given branch,
> it rapidly grew into a pain: I had to read assembly code, guess
> which register was matching which variable, etc... It works, but
> it takes too much time, and printk() rapidly becomes a temptation :)
>
> It too low-level, but its use through perf brings all that to the
> human dimension.
>
> So, I'm not sure we really need to have such tight syntax between
> both, since the debugfs more likely behaves as a gateway, something
> I don't imagine to be used broadly as an end-user interface but mostly
> as a kernel interface.

I see, and I also found that the syntax never be same, since
perf-probe doesn't need argument names etc. kprobe_events
interface may be mostly for higher level scripts or programs.

> Especially we shouldn't break the perf probe syntax simplicity
> just because we want both syntaxes to be tight.

Agreed. OK, so let it be :-)

> (Nothing related to the event/group feature itself, it's just an
> opinion about the need of this similarity between two interfaces).
>
>
>>   perf probe "newgroup:newevnt=func:10 arg1 arg2"
>>
>> adds the newevent under newgroup. On the other hand, ftrace
>> users can also add a new event as below;
>>
>>   echo 'newgroup:newevent=func+0x18 arg1=$a1 arg2=$a2'>  kprobe_events
>>
>> Any thoughts?
>
>
> Yeah, that would probably be nice, especially once we have a good
> collection of probes to handle and to organize in a sensical output.
>
> But it would be better to have that as an optional thing:
>
> 	perf probe "[group:name=]func...."


Sure, of course it should be optional. :-)

> so that we keep the simplicity of:
>
> 	perf probe func
>
> I guess you meant it as optional already, but just in case... :)

Thank you :-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

