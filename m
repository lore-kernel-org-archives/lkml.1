Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbZKBVRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbZKBVRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbZKBVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:17:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbZKBVRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:17:18 -0500
Message-ID: <4AEF4C29.2060501@redhat.com>
Date: Mon, 02 Nov 2009 16:16:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9r?= =?ISO-8859-1?Q?ic_Weisbecker?= 
	<fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes and
 perf-probe syntax changes
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <4AE9C919.4070003@redhat.com>
In-Reply-To: <4AE9C919.4070003@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> Ingo Molnar wrote:
>> What we want here is two fold:
>>
>>    - enable kprobes event support when perf events is enabled and kprobes
>>      is enabled. We dont want another config option for it.
>
> Sure, at least that combination should enable kprobe-tracer forcibly.

Hmm, someone may not want to enables kprobe-tracer. Perhaps,
"default y if (EVENT_PROFILE)" is enough, isn't it?


>> A few further (and very small) UI tweaks i'd suggest:
>>
>> Firstly, could we please make the first probe inserted named plain after
>> the symbol it specifies, with no _0 postfix? I.e. instead of:
>>
>>              7358  perfprobe:__switch_to_0  #      0.000 M/sec
>>
>> we'd get:
>>
>>              7358  perfprobe:__switch_to    #      0.000 M/sec
>>
>> Subsequent probes for the same symbol can be named _1, _2 - but the
>> first symbol should not have this needless post-fix.
>
> Ah, this prefix means the offset from the symbol. Of course we can
> remove it if the offset == 0. Or, would you think make the postfix
> sequence number of probes on the same symbol?

If so, we'd better have --list option before that and check the
postfix is already used, since we may not want to overwrite
existing probes, right?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

