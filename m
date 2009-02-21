Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZBUVdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZBUVdD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 16:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbZBUVcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 16:32:53 -0500
Received: from mail-fx0-f164.google.com ([209.85.220.164]:34679 "EHLO
	mail-fx0-f164.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZBUVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 16:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VN1QEXFFqU5luTZ/0Vk0lXQw/sMcdGQyF5C1MZF9wq8NMKoStTIPRRD0aS5HBgCOnR
         xyiB+MP4oIJVggvF6Hg0a5eDk6rp9GchNFEnLKC7df0uwVuMMgjsmBARhqMcEePiVMSH
         5S0P4RFczqdRNPTNRQu6RtSQsdcAbZNMCKJ7Q=
MIME-Version: 1.0
In-Reply-To: <20090221211908.GA6798@silver.sucs.org>
References: <20090221211908.GA6798@silver.sucs.org>
Date: Sat, 21 Feb 2009 22:32:50 +0100
Message-ID: <19f34abd0902211332r6fd0a1e3l3cee6c49e85f879e@mail.gmail.com>
Subject: Re: Is kmemcheck currently broken on tip?
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/21 Sitsofe Wheeler <sitsofe@yahoo.com>:
> Hi,
>
> I've been trying to test kmemcheck in linux-tip on my EeePC and things
> have been going suspiciously not so slow with little extra memory used
> (at least compared to the last time I used kmemcheck). While I see
> [    0.063412] kmemcheck: "Bugs, beware!"
> in dmesg, I'm not sure kmemcheck is working especially since nothing is
> flagged when I trigger the issue described in
> http://marc.info/?l=linux-kernel&m=123472656015761&w=1 ...

Thanks for the tip! :-D I get this:

[14017.055042] WARNING: kmemcheck: Caught 8-bit read from freed memory (f5cd800)
[14017.063065] 8083cdf5000000000000000000000000000000001480cdf51480cdf51c80cdf5
[14017.089001]  i i i i f f f f f f f f f f f f f f f f f f f f f f f f f f f f
[14017.114942]          ^
[14017.117918]
[14017.120042] Pid: 2428, comm: cat Not tainted (2.6.29-rc4 #241) 945P-A
[14017.127181] EIP: 0060:[<c11a8e39>] EFLAGS: 00010293 CPU: 0
[14017.133351] EIP is at strnlen+0x9/0x20
[14017.137739] EAX: f5cd8004 EBX: c1621922 ECX: f5cd7000 EDX: ffffeffa
[14017.144699] ESI: ffffffff EDI: f5cd7000 EBP: f5cf7d8c ESP: c17885a4
[14017.151658]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[14017.157732] CR0: 8005003b CR2: f6c04070 CR3: 35cde000 CR4: 000006d0
[14017.164699] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[14017.171665] DR6: ffff4ff0 DR7: 00000400
[14017.176151]  ? [<c102775b>] update_curr+0x1eb/0x200
[14017.182785]  ? [<c100e36b>] save_stack_trace_bp+0x2b/0x70
[14017.189980]  ? [<c1022adf>] kmemcheck_error_save+0xdf/0x180
[14017.197336]  ? [<c1022c19>] kmemcheck_read_strict+0x79/0x90
[14017.204702]  ? [<c1022c61>] kmemcheck_read+0x31/0x60
[14017.211438]  ? [<c11a8e39>] strnlen+0x9/0x20
[14017.217481]  ? [<c11a8e39>] strnlen+0x9/0x20
[14017.223506]  ? [<c1023095>] kmemcheck_access+0x255/0x460
[14017.230599]  ? [<c1022deb>] kmemcheck_hide_addr+0xb/0x30
[14017.237687]  ? [<c1023501>] kmemcheck_fault+0x81/0x90
[14017.244517]  ? [<c101df32>] do_page_fault+0x1a2/0x250
[14017.251346]  ? [<c1022bea>] kmemcheck_read_strict+0x4a/0x90
[14017.258707]  ? [<c101dd90>] do_page_fault+0x0/0x250
[14017.265367]  ? [<c1501d95>] error_code+0x6d/0x74
[14017.271752]  ? [<c102007b>] untrack_pfn_vma+0xcb/0xe0
[14017.278587]  ? [<c101dd90>] do_page_fault+0x0/0x250
[14017.285239]  ? [<c11a8e39>] strnlen+0x9/0x20
[14017.291254]   [<c11a7bf8>] string+0x28/0xd0
[14017.297183]   [<c11a8124>] vsnprintf+0x484/0xac0
[14017.303556]  ? [<c10225f0>] kmap_atomic_prot+0x40/0xc0
[14017.310469]  ? [<c107f733>] get_page_from_freelist+0x2f3/0x4b0
[14017.318094]  ? [<c102367e>] kmemcheck_pte_lookup+0xe/0x40
[14017.325265]  ? [<c102373f>] kmemcheck_shadow_lookup+0x1f/0x50
[14017.332784]  ? [<c1022bea>] kmemcheck_read_strict+0x4a/0x90
[14017.340160]  ? [<c102373f>] kmemcheck_shadow_lookup+0x1f/0x50
[14017.347681]  ? [<c1022c61>] kmemcheck_read+0x31/0x60
[14017.354417]  ? [<c1044712>] param_attr_show+0x12/0x50
[14017.361251]  ? [<c1044712>] param_attr_show+0x12/0x50
[14017.368062]  ? [<c1023095>] kmemcheck_access+0x255/0x460
[14017.375153]  ? [<c102367e>] kmemcheck_pte_lookup+0xe/0x40
[14017.382330]  ? [<c102367e>] kmemcheck_pte_lookup+0xe/0x40
[14017.389494]  ? [<c1022deb>] kmemcheck_hide_addr+0xb/0x30
[14017.412120] fill_read_buffer: module_attr_show+0x0/0x40 returned bad count

(Hm, maybe storing the unreliable stack frames wasn't such a good idea
at all -- all they do is fill up the space.)

As for your question, tip/kmemcheck SHOULD work, but we have a lot of
improvements coming up soon.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
