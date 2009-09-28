Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZI1Qsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZI1Qsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI1Qsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:48:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZI1Qsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:48:41 -0400
Message-ID: <4AC0E9A4.1020605@redhat.com>
Date: Mon, 28 Sep 2009 12:51:48 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap <systemtap@sourceware.org>
Subject: Re: [RFC PATCH tracing/kprobes 4/5] perf: Support perf kprobe command
 for kprobe-event setup helper
References: <20090925191424.12939.91503.stgit@omoto>	 <20090925191546.12939.75278.stgit@omoto> <1253955120.12145.2.camel@frodo>
In-Reply-To: <1253955120.12145.2.camel@frodo>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2009-09-25 at 12:15 -0700, Masami Hiramatsu wrote:
> 
>> +
>> +#define MAX_CMDLEN 256
>> +
>> +static int synthesize_probepoint(struct probe_point *pp)
>> +{
>> +	char *buf;
>> +	int i, len, ret;
>> +	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
>> +	len = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
> 
> What happens if func and offset is too big for MAX_CMDLEN?

Oops, it must be checked.

> 
>> +	for (i = 0; i<  pp->nr_args; i++) {
> 
> Can you have a case where pp->nr_args == 0?

Sure, I'll check that.

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

