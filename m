Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbZGJT5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbZGJT5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZGJT5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:57:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZGJT5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:57:11 -0400
Message-ID: <4A579D9A.1010306@redhat.com>
Date: Fri, 10 Jul 2009 15:59:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip -v11 11/11] tracing: Add kprobes event profiling
 interface
References: <20090709202220.13223.97114.stgit@localhost.localdomain> <20090709202327.13223.16418.stgit@localhost.localdomain> <4A56E3D8.3010806@cn.fujitsu.com>
In-Reply-To: <4A56E3D8.3010806@cn.fujitsu.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Li Zefan wrote:
>> +Event Profiling
>> +---------------
>> + You can check the total number of probe hits and probe miss-hits via
>> +/sys/kernel/debug/tracing/kprobe_profile.
>> + The fist column is event name, the second is the number of probe hits,
> 
> s/fist/first

Oops, fixed.

> 
>> +the third is the number of probe miss-hits.
>> +
>> +
> ...
>> +/* Probes profiling interfaces */
>> +static int profile_seq_show(struct seq_file *m, void *v)
>> +{
>> +	struct trace_probe *tp = v;
>> +
>> +	if (tp == NULL)
>> +		return 0;
>> +
> 
> tp will never be NULL, which is guaranteed by seq_file

OK, fixed.

>> +	seq_printf(m, "%s", tp->call.name);
>> +
>> +	seq_printf(m, "\t%8lu %8lu\n", tp->nhits,
>> +		   probe_is_return(tp) ? tp->rp.kp.nmissed : tp->kp.nmissed);
>> +
>> +	return 0;
>> +}

Thank you for review!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

