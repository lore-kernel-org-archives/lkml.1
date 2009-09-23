Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZIWIbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZIWIbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZIWIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:31:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbZIWIbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:31:38 -0400
Message-ID: <4AB9DCC8.5050603@redhat.com>
Date: Wed, 23 Sep 2009 11:31:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Mike Galbraith <efault@gmx.de>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [perf] Finding uninstalled modules Was Re: mailing list for trace
 users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com> <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net> <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net> <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
In-Reply-To: <20090922201746.GH5216@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 11:17 PM, Arnaldo Carvalho de Melo wrote:
>
>> $ perf annotate -v -v -k ~avi/kvm/linux-2.6/vmlinux -m vmx_vcpu_run  |
>>      
> Here is the problem, he is passing a vmlinux, that way we don't parse
> /proc/kallsyms, so no module symbols, he uses -m to load the modules
> symbols but mod_dso__load_module_paths only looks at /lib/modules/, i.e.
> installed modules.
>
> I guess Avi hasn't installed modules, right? So the right fix for this
> case is to figure out where modules are from the path given to -k, i.e.
> we first use ~avi/kvm/linux-2.6/ as the modules path prefix and then
> fallback to /lib/modules if we can't find modules there, right?
>    

Modules were installed (I always load them with modprobe).  It's 
possible that the installed modules were a later version than the loaded 
modules, but Mike's reply leads me to believe there was a real bug there.

-- 
error compiling committee.c: too many arguments to function

