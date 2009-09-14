Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbZINC7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbZINC7w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 22:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZINC7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 22:59:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:24384 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbZINC7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 22:59:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H+mrya8fRFo6zBcU5xK42vE1kgkwwzSVmWcgEnrsgOkor9SaQD1ACnxRgHGsUPqcRL
         fi7f5L/2RGTdxWRSJorahksOt+kvNWEp7zxD9qOGlY1BhRptc0Wg/UOF2hg7hbAe1ZTW
         bJjBI5LgAjoni6DXgkKIPG+d+VtiuhthSciWY=
Date: Mon, 14 Sep 2009 04:59:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based event
	tracer update and perf support
Message-ID: <20090914025949.GB14306@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090911013332.GB16396@nowhere> <4AAA74D2.9060203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAA74D2.9060203@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 12:03:30PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> May be another step in the todo-list that would be nice: define the format
>> for a type. Like it's done from ftrace events.
>
> Thanks!
>
> BTW, I'm not sure what the type means. Each event already has its own
> event ID and event_call. Could you tell me which part of ftrace I should
> refer to ?
>




Actually I meant the format for a field.
Say you define filename=arg1, it would be nice to have

	print "%s", filename

in the format file.

Hmm, now that I think about it, we can't dereference an array...for now :-)


>> I guess we should choose between the low level, very granular
>> but uninviting method "kprobe + record + trace" and also an all
>> in one quick approach.
>>
>> And that could be chosen from perf kprobe:
>>
>> Low level:
>>
>> perf kprobe --define-only [-p|-r] [probe_name] -a1 [arg1] -a2 [arg2] \
>> 	    --format="%s %...."
>>
>> perf record -e kprobes:probe_name
>> perf trace
>>
>> Quick:
>>
>> perf kprobe -p probe_name -a1 ..... cmdline| -a
>>
>> And after the profiled task is finished, it could launch perf trace
>> by itself (or wait for a Ctrl + C if -a/wide profiling)
>
> Another thought: expand record subcommand.
>
> perf record -E "p|r:probe_name,place,arg1,arg2..."
> perf trace
>
> And kprobe accept multiple definitions
>
> perf kprobe -E "p|r:probe_name,place,arg1,arg2..." -E ...


Well, perf record could also support multiple definitions
too...

