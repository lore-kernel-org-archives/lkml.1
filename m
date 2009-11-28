Return-Path: <linux-kernel-owner+w=401wt.eu-S1752179AbZK1QMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbZK1QMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 11:12:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZK1QMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 11:12:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZK1QMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 11:12:36 -0500
Message-ID: <4B114BB4.6080307@redhat.com>
Date: Sat, 28 Nov 2009 11:11:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v6 04/11] kprobes: Jump optimization sysctl interface
References: <20091125165510.6073.48721.stgit@harusame>	<20091125165541.6073.43956.stgit@harusame> <m1my27txdo.fsf@fess.ebiederm.org>
In-Reply-To: <m1my27txdo.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Masami Hiramatsu<mhiramat@redhat.com>  writes:
>
>> Add /proc/sys/debug/kprobes-optimization sysctl which enables and disables
>> kprobes jump optimization on the fly for debugging.
>>
>> Changes in v6:
>> - Update comments and coding style.
>>
>
> This will break when it hits the linux-next.  As ctl_name has been
> removed in the sysctl tree.  Not setting ctl_name is equivalent
> to setting ctl_name = CTL_UNNUMBERED.  It is 0 in both cases.
> So you can safely drop touches of ctl_name.
>
> Ideally you would also call register_sysctl_paths from kernel/kprobes.c
> and not add to the ifdef horror that is kernel/sysctl.c but that
> is probably more trouble than it is worth right now.    One way or
> another there is going to be at least a minor conflict when this code
> merges with the sysctl tree.

Thanks for telling me!
OK, so I'll remove that line.

Thank you,

>>   #include<asm/uaccess.h>
>>   #include<asm/processor.h>
>> @@ -1621,6 +1622,18 @@ static struct ctl_table debug_table[] = {
>>   		.proc_handler	= proc_dointvec
>>   	},
>>   #endif
>> +#if defined(CONFIG_OPTPROBES)
>> +	{
>> +		.ctl_name	= CTL_UNNUMBERED,
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Please remove this line.
>> +		.procname	= "kprobes-optimization",
>> +		.data		=&sysctl_kprobes_optimization,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_kprobes_optimization_handler,
>> +		.extra1		=&zero,
>> +		.extra2		=&one,
>> +	},
>> +#endif
>>   	{ .ctl_name = 0 }
>>   };
>
>
> Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

