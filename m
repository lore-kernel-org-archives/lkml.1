Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZIWIiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZIWIiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbZIWIiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:38:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZIWIiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:38:16 -0400
Date: Wed, 23 Sep 2009 01:37:52 -0700
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [perf] Finding uninstalled modules Was Re: mailing list for
	trace users
Message-ID: <20090923083751.GB6464@ghostprotocols.net>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net> <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net> <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net> <4AB9DCC8.5050603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB9DCC8.5050603@redhat.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Sep 23, 2009 at 11:31:04AM +0300, Avi Kivity escreveu:
> On 09/22/2009 11:17 PM, Arnaldo Carvalho de Melo wrote:
>>
>>> $ perf annotate -v -v -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run  |
>>>      
>> Here is the problem, he is passing a vmlinux, that way we don't parse
>> /proc/kallsyms, so no module symbols, he uses -m to load the modules
>> symbols but mod_dso__load_module_paths only looks at /lib/modules/, i.e.
>> installed modules.
>>
>> I guess Avi hasn't installed modules, right? So the right fix for this
>> case is to figure out where modules are from the path given to -k, i.e.
>> we first use ~avi/kvm/linux-2.6/ as the modules path prefix and then
>> fallback to /lib/modules if we can't find modules there, right?
>>    
>
> Modules were installed (I always load them with modprobe).  It's  
> possible that the installed modules were a later version than the loaded  
> modules, but Mike's reply leads me to believe there was a real bug there.

Yeah, I'm rewriting the module symbol lookup code in perf, they should
really be maps backed by DSOs, just like shared libraries, only that
shared among all threads.

Will continue working on this tomorrow. Now need to get some sleep, else
I'll miss the first day of plumbers 8)

- Arnaldo
