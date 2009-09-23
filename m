Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZIWJQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZIWJQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZIWJQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:16:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbZIWJQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:16:00 -0400
Date: Wed, 23 Sep 2009 11:15:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Mike Galbraith <efault@gmx.de>,
       rostedt@goodmis.org, LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [perf] Finding uninstalled modules Was Re: mailing list for
	trace users
Message-ID: <20090923091549.GB21748@elte.hu>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net> <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net> <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net> <4AB9DCC8.5050603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB9DCC8.5050603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 09/22/2009 11:17 PM, Arnaldo Carvalho de Melo wrote:
>>
>>> $ perf annotate -v -v -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run  |
>>>      
>> Here is the problem, he is passing a vmlinux, that way we don't parse
>> /proc/kallsyms, so no module symbols, he uses -m to load the modules
>> symbols but mod_dso__load_module_paths only looks at /lib/modules/, i.e.
>> installed modules.
>>
>> I guess Avi hasn't installed modules, right? So the right fix for 
>> this case is to figure out where modules are from the path given to 
>> -k, i.e. we first use ~avi/kvm/linux-2.6/ as the modules path prefix 
>> and then fallback to /lib/modules if we can't find modules there, 
>> right?
>
> Modules were installed (I always load them with modprobe).  It's 
> possible that the installed modules were a later version than the 
> loaded modules, but Mike's reply leads me to believe there was a real 
> bug there.

Yes, definitely - 'perf annotate' not giving you what you expected is a 
bug by definition - regardless of how you build your kernel, how you 
loaded your modules and how the symbols and tables are distributed 
across the system.

	Ingo
