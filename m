Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbXC1O4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbXC1O4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXC1O4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:56:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:6309 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbXC1O4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=reM1TotBprZu2Lo4FSzeaXcNvO/pdrS0O1dKAYO5OusYLSdMy4NOFhTivstZL7ozPbyZ75Zpnydqx+G0ghabYtP1OoNJyu51CYBiy9OaBXDNFWLm58Z2IWXJW6S+Lm2raMR/nbmwDUbeqPAMt5PbBRbTw4HHyS9FPDFqPCqtXKE=
Message-ID: <460A8203.20207@googlemail.com>
Date: Wed, 28 Mar 2007 16:56:03 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc5
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <46096834.5050508@googlemail.com> <200703281630.59191.ak@suse.de>
In-Reply-To: <200703281630.59191.ak@suse.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen napisał(a):
> On Tuesday 27 March 2007 20:53, Michal Piotrowski wrote:
>> Linus Torvalds napisał(a):
>>> There's various fixes here, ranging from some architecture updates (ia64, 
>>> ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
>>>
>>> And random one-liners.
>>>
>> I found this in mm snapshot
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/1367.html
>> it's in mainline too.
>>
>> Andi, any progress with this bug?
> 
> Can you test this patch please? 
> 

BUG: using smp_processor_id() in preemptible [00000001] code: mount/7245 
is fixed, thanks.


but I still get this

[  208.523901] =================================
[  208.529739] [ INFO: inconsistent lock state ]
[  208.534087] 2.6.21-rc5-g28defbea-dirty #131
[  208.538260] ---------------------------------
[  208.542611] inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
[  208.548600] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  208.553553]  (oprofilefs_lock){+-..}, at: [<fdc85b6a>] nmi_cpu_setup+0x15/0x4f [oprofile]
[  208.561800] {hardirq-on-W} state was registered at:
[  208.566665]   [<c013dba4>] __lock_acquire+0x442/0xba1
[  208.571765]   [<c013e36b>] lock_acquire+0x68/0x82
[  208.576519]   [<c031bb37>] _spin_lock+0x35/0x42
[  208.581102]   [<fdc85343>] oprofilefs_ulong_from_user+0x4e/0x74 [oprofile]
[  208.588026]   [<fdc85393>] ulong_write_file+0x2a/0x38 [oprofile]
[  208.594084]   [<c0172693>] vfs_write+0xaf/0x138
[  208.598658]   [<c0172c5d>] sys_write+0x3d/0x61
[  208.603171]   [<c0104060>] syscall_call+0x7/0xb
[  208.607751]   [<ffffffff>] 0xffffffff
[  208.611478] irq event stamp: 575782
[  208.614960] hardirqs last  enabled at (575781): [<c0102ac2>] default_idle+0x3e/0x59
[  208.622645] hardirqs last disabled at (575782): [<c0104ae9>] call_function_interrupt+0x29/0x38
[  208.631281] softirqs last  enabled at (575768): [<c0126537>] __do_softirq+0xe4/0xea
[  208.638965] softirqs last disabled at (575759): [<c01069b5>] do_softirq+0x64/0xd1
[  208.646478]
[  208.646479] other info that might help us debug this:
[  208.653003] no locks held by swapper/0.
[  208.656832]
[  208.656833] stack backtrace:
[  208.661199]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[  208.666350]  [<c0105720>] show_trace+0x12/0x14
[  208.670811]  [<c01057d2>] dump_stack+0x16/0x18
[  208.675272]  [<c013c57f>] print_usage_bug+0x140/0x14a
[  208.680336]  [<c013cd8a>] mark_lock+0xa1/0x40b
[  208.684796]  [<c013db15>] __lock_acquire+0x3b3/0xba1
[  208.689775]  [<c013e36b>] lock_acquire+0x68/0x82
[  208.694410]  [<c031bb37>] _spin_lock+0x35/0x42
[  208.698869]  [<fdc85b6a>] nmi_cpu_setup+0x15/0x4f [oprofile]
[  208.704540]  [<c0112a61>] smp_call_function_interrupt+0x3a/0x56
[  208.710470]  [<c0104af3>] call_function_interrupt+0x33/0x38
[  208.716053]  [<c01023b8>] cpu_idle+0xb6/0xeb
[  208.720342]  [<c0113bb0>] start_secondary+0x333/0x33b
[  208.725407]  [<00000000>] 0x0
[  208.728397]  =======================


Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
