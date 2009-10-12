Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbZJLTuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbZJLTuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758044AbZJLTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:50:07 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:34690 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758018AbZJLTuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CUQ00ZjKNQDqJDMWjjzqfocGHbD0j4m9jMno9lOkE34eIeQlbLXj5/fe2rgMvm5GLm
         VGX2Wk13sfgJbfXoCP1tZ+OhauFkcE0KriovEgFEPUf9SHAyERsbMeJJqviksenqbocT
         5GYOJh5g+xcFRQh1iOrIgdtN9wm+uY0r53uw0=
Date: Mon, 12 Oct 2009 21:48:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v3 4/7] tracing/kprobes: Avoid field
	name confliction
Message-ID: <20091012194852.GB4748@nowhere>
References: <20091007222733.1684.32035.stgit@dhcp-100-2-132.bos.redhat.com> <20091007222807.1684.26880.stgit@dhcp-100-2-132.bos.redhat.com> <20091012173752.GB5059@nowhere> <4AD37FEF.9050807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD37FEF.9050807@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 03:13:51PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> The conflict issue might not be obvious for a user desperately trying to set
>> a kprobe. Even for other failcases, it might not be obvious (blacklisted
>> symbols, syntax errors...)
>>
>> May be should you improve the error granularity and print a KERN_DEBUG
>> message?
>
> Agreed, and kprobes error handling should be improved too (in the most cases,
> it just returns -EINVAL).
>
> Thank you.
>


And btw, I'm enable to create a probe, neither through ftrace nor perf:

	$ sudo ./perf probe -P 'p:sys_close sys_close $retval'
	Adding new event: p:sys_close sys_close+0 $retval

	Error: Failed to create event: Invalid argument


	# echo 'p:sys_open sys_open $retval' > /debug/tracing/kprobe_events 
	bash: echo: write error : Invalid argument

I suspect I missed something very obvious with the syntax :)

I've applied your patches in:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

Thanks.



