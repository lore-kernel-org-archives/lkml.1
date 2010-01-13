Return-Path: <linux-kernel-owner+w=401wt.eu-S1756494Ab0AMV67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0AMV67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:58:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555Ab0AMV66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:58:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab0AMV65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:58:57 -0500
Message-ID: <4B4E41FF.4020800@redhat.com>
Date: Wed, 13 Jan 2010 16:58:23 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Mark Wielaard <mjw@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>	 <20100112045454.GJ5243@nowhere> <1263272933.28171.3804.camel@gandalf.stny.rr.com>
In-Reply-To: <1263272933.28171.3804.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Tue, 2010-01-12 at 05:54 +0100, Frederic Weisbecker wrote:
> 
>> Now what if I want to launch ls and want to profile a function
>> inside. What can I do with a trace event. I can't create the
>> probe event based on a pid as I don't know it in advance.
>> I could give it the ls cmdline and it manages to activate
>> on the next ls launched. This is racy as another ls can
>> be launched concurrently.
> 
> You make a wrapper script:
> 
> #!/bin/sh
> <add probe to ls with pid> $$
> exec $*
> 
> I do this all the time to limit the function tracer to a specific app.
> 
> #!/bin/sh
> echo $$ > /debug/tracing/set_ftrace_pid
> echo function > /debug/tracing/current_tracer
> exec $*

I recommend you to add below line at the end of the script,
from my experience. :)

echo nop > /debug/tracing/current_tracer

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

