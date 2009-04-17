Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbZDQASw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbZDQASw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZDQASo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:18:44 -0400
Received: from gw.goop.org ([64.81.55.164]:46597 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbZDQASn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:18:43 -0400
Message-ID: <49E7CADE.1060202@goop.org>
Date: Thu, 16 Apr 2009 17:18:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal> <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <49E7C74A.8030100@goop.org> <20090417001317.GB20513@Krystal>
In-Reply-To: <20090417001317.GB20513@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
>> Are they?  They're generally considered to be "free", because the call  
>> and return are predicted 100% accurately.
>>
>>     
>
> Adding a simple function call within the tracer fast path, in LTTng, has
> a very measurable performance impact on the tbench workload. This is why
> I don't use any function call-based trace clocks in LTTng, but rather my
> own inline trace clock.

I'm a bit concerned about all the code that tracing puts inline though.  
It seems it would put quite a lot of icache overhead on the codepath 
when the tracepoint is disabled, not least because its duplicated in 
every instance of the tracepoint.  And if the compiler decides to put 
the unlikely() branch code out of line, then that's the same as making 
it a function call (except that if it is a function call, all the 
tracepoints will share the same code, and get a higher likelihood of 
getting icache hits).


    J
