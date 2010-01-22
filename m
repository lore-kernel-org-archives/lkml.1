Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245Ab0AVVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab0AVVAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 16:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276Ab0AVVAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:00:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0AVVAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:00:14 -0500
Message-ID: <4B5A11BB.9010801@redhat.com>
Date: Fri, 22 Jan 2010 15:59:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v8 0/9] kprobes: Kprobes jump optimization support
References: <20100122185450.9022.87506.stgit@dhcp-100-2-132.bos.redhat.com> <20100122185816.GB25202@Krystal>
In-Reply-To: <20100122185816.GB25202@Krystal>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Hi,
>>
>> Here are the patchset of the kprobes jump optimization v8
>> (a.k.a. Djprobe). This version is just moving onto
>> 2.6.33-rc4-tip. Ingo, I assume its a good timing to
>> push this code onto -tip tree (maybe developing branch?),
>> since people can test it with perf-probe.
>>
>> I've decided to make a separated series of patches of
>> jump optimization with text_poke_smp() which is
>> 'officially' supported on Intel's processors.
>> So, this version of patches are just updated against
>> the latest tip/master, no other updates are included.
>>
>> I know that int3-bypassing method (text_poke_fixup())
>> is currently unofficially believed as safe. But we
>> need to get more official answers from x86 vendors.
>> Moreover, we need to tweak entry_*.S for preventing
>> recursive NMI, because int3 inside NMI handler will
>> unblock NMI blocking. I'd like to push it after this
>> series of patches are merged.
>>
>> Anyway, thanks Mathieu and Peter, for helping me to
>> implement it and organizing discussion points about
>> int3-bypass XMC!
>>
>> These patches can be applied on the latest -tip.
>>
>> Changes in v8:
>>  - Update patches against the latest tip/master.
>>  - Drop text_poke_fixup() related patches.
>>  - Update benchmark results and add jprobes and kprobe(post-handler)
>>    results.
>>
>> And kprobe stress test didn't found any regressions - from kprobes,
>> under kvm/x86.
>>
>> TODO:
>>  - Support NMI-safe int3-bypassing text_poke.
> 
> Please have a look at:
> 
> "x86 NMI-safe INT3 and Page Fault"
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=90516e3c718e0502f6f2eb616fad4447645ca47d
> 
> and
> 
> "x86_64 page fault NMI-safe"
> http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=ad1bf11a68c35a44edd8d686a0842896f408e17c
> 
> That turns this TODO into the "done" section ;)
> 
> I've been using these patches in the lttng tree for 1-2 years.

Hi Mathieu,

Sure, those looks good to me too. Thanks!

I'd just like to separate this issue from kprobe jump optimization
itself this time, because;
- text_poke_fixup() is not necessary to kprobes :-)
- the int3-bypassing text_poke method is still unofficially ensured
  by intel people. and we also need to require answers from other
  x86 compatible processor vendors. 

Anyway, my next series of patches will contain those patches.

BTW, I think your 2nd patch seems good to send to upstream separately.

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

