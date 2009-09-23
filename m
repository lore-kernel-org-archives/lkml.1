Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbZIWOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbZIWOBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZIWOBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:01:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52118 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbZIWOBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:01:17 -0400
Message-ID: <4ABA2A0B.1010103@redhat.com>
Date: Wed, 23 Sep 2009 17:00:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>	 <4AB9F08E.1020106@redhat.com> <1253705515.7835.41.camel@marge.simson.net>	 <4ABA1B75.7040900@redhat.com>  <4ABA1E3B.40800@redhat.com> <1253713800.7816.15.camel@marge.simson.net>
In-Reply-To: <1253713800.7816.15.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 04:50 PM, Mike Galbraith wrote:
> On Wed, 2009-09-23 at 16:10 +0300, Avi Kivity wrote:
>    
>> On 09/23/2009 03:58 PM, Avi Kivity wrote:On 09/23/2009 03:58 PM, Avi
>> Kivity wrote:
>>      
>>> Not for me.  'perf report', for example, shows
>>>
>>>      63.08%  qemu-system-x86
>>> [kernel]                                              [k] packet_exit
>>>       4.71%  qemu-system-x86
>>> [kernel]                                              [k] hpet_next_event
>>>       4.38%             init
>>> [kernel]                                              [k]
>>> mwait_idle_with_hints
>>>
>>> While 'perf top' still shows vmx_vcpu_run.
>>>
>>>        
>> strace says:
>>
>>      getcwd("/home/avi/kvm/linux-2.6"..., 4096) = 24
>>      ...
>>      [no chdir]
>>      ...
>>      open("kernel/arch/x86/kvm/kvm-intel.ko", O_RDONLY) = -1 ENOENT (No
>> such file or directory)
>>      
> *blink*
>
>    
>> That "kernel/" looks like it was meant for /lib/modules, not a kernel
>> tree.  If I run 'perf report' from /lib/modules/2.6.31 I see vmx_vcpu_run.
>>      
> So I need what's in your modules.dep to figure out where the rest of the
> path went.
>
>    

Mine says:

   kernel/arch/x86/kvm/kvm.ko:
   kernel/arch/x86/kvm/kvm-intel.ko: kernel/arch/x86/kvm/kvm.ko

Which is reasonable for /lib/modules/2.6.31, not for a source directory.

> /lib/modules/2.6.32-tip-smp/kernel/arch/x86/kvm/kvm-intel.ko
>
> static int mod_dso__load_module_paths(struct mod_dso *self)
> {
>          struct utsname uts;
>          int count = 0, len;
>          char *line = NULL;
>          FILE *file;
>          char *path;
>          size_t n;
>
>          if (uname(&uts)<  0)
>                  goto out_failure;
>
>          len = strlen("/lib/modules/");
>          len += strlen(uts.release);
>          len += strlen("/modules.dep");
>
>          path = calloc(1, len);
>    

len + 1

>          if (path == NULL)
>                  goto out_failure;
>
>          strcat(path, "/lib/modules/");
>          strcat(path, uts.release);
>          strcat(path, "/modules.dep");
>
>          file = fopen(path, "r");
>
>    

-- 
error compiling committee.c: too many arguments to function

