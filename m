Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZIPOaE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZIPOaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:30:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZIPOaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:30:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZIPOaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:30:01 -0400
Message-ID: <4AB0F6B0.8090400@redhat.com>
Date: Wed, 16 Sep 2009 10:31:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 3/6] ftrace: Fix trace_remove_event_call()
 to lock trace_event_mutex
References: <20090914204847.18779.69409.stgit@dhcp-100-2-132.bos.redhat.com>	 <20090914204912.18779.68734.stgit@dhcp-100-2-132.bos.redhat.com> <1253071051.20020.177.camel@gandalf.stny.rr.com>
In-Reply-To: <1253071051.20020.177.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Mon, 2009-09-14 at 16:49 -0400, Masami Hiramatsu wrote:
> 
>>
>> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
>> index 38e82a5..a3d6bad 100644
>> --- a/kernel/trace/trace_events.c
>> +++ b/kernel/trace/trace_events.c
>> @@ -1055,6 +1055,9 @@ static void remove_subsystem_dir(const char *name)
>>  	}
>>  }
>>  
>> +/*
>> + * Must be called under locking both of event_mutex and trace_event_mutex.
>> + */
>>  static void __trace_remove_event_call(struct ftrace_event_call *call)
>>  {
>>  	ftrace_event_enable_disable(call, 0);
>> @@ -1071,7 +1074,9 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
>>  void trace_remove_event_call(struct ftrace_event_call *call)
> 
> Is this from a previous patch set, because I can't find this in either
> my tree or tip/master.

Right, this bug is from my patch:
tracing: Ftrace dynamic ftrace_event_call support

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

