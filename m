Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbZDOQIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbZDOQIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZDOQIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:08:07 -0400
Received: from gw.goop.org ([64.81.55.164]:56323 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbZDOQIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:08:05 -0400
Message-ID: <49E6065B.7080409@goop.org>
Date: Wed, 15 Apr 2009 09:07:55 -0700
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
References: <20090414172337.280621613@goodmis.org> <20090414172640.796858018@goodmis.org> <49E51FC1.8090306@goop.org> <20090415014548.GA7984@Krystal>
In-Reply-To: <20090415014548.GA7984@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>> -#define __DO_TRACE(tp, proto, args)					\
>> -	do {								\
>> +#define DEFINE_DO_TRACE(name, proto, args)				\
>> +	void __do_trace_##name(struct tracepoint *tp, TP_PROTO(proto))	\
>>     
>
> I fear that won't work with "void" prototype. If we need this kind of
> flexibility, we will need to create a special case for empty prototype.
>   

Yes, that has been a bit awkward.  I couldn't find a way to create a 
no-param tracepoint, and so ended up passing a dummy arg.  Stupid C syntax.

On the other hand, I can get something that actually compiles this way...

    J
