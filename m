Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbYIWOwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbYIWOwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYIWOw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:52:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422AbYIWOw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:52:28 -0400
Message-ID: <48D901FE.5060604@redhat.com>
Date: Tue, 23 Sep 2008 10:49:34 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Martin Bligh <mbligh@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>	 <48D7F5E8.3000705@redhat.com>	 <33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>	 <48D81B5F.2030702@redhat.com>	 <33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>	 <48D832B6.3010409@redhat.com> <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com>
In-Reply-To: <33307c790809221712x4fbd9781u958c98d4585e92a9@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Martin Bligh wrote:
>>> But perhaps it would be better if we started with a discussion of which
>>> platforms can't do global timestamps, and why not? I know some of them
>>> are fixable, but perhaps not all.
>> For example, my laptop (this machine/Core2Duo) doesn't return correct TSC. :-(
> 
> Can you define incorrect for me (in this case)?

On my laptop, TSC is disabled at boot time.

$ dmesg | grep TSC
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 4246549092 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.

$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping	: 6
cpu MHz		: 1000.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3998.45
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 15
model name	: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping	: 6
cpu MHz		: 1000.000
cache size	: 4096 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc arch_perfmon pebs bts pni
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr lahf_lm
bogomips	: 3994.43
clflush size	: 64
power management:

Actually, I had measured TSC drifting and reported to systemtap-bugzilla
http://sources.redhat.com/bugzilla/show_bug.cgi?id=3916#c19

Curiously, I've tested on another Core2Duo laptop, which cpu is same model and
same stepping, but on that laptop I couldn't see TSC drifting.
So I think this might be a product level issue and a rare case...


> We had similar problems with some AMD platforms that we can fix by syncing
> the TSCs on exit_idle, etc.

Hmm, very interesting. :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


