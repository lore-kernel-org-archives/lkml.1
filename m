Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0CDB3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 20:29:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:59847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770Ab0CDB24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 20:28:56 -0500
Message-ID: <4B8F0CD0.1040507@kernel.org>
Date: Thu, 04 Mar 2010 10:28:48 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com>
In-Reply-To: <4B8E83D4.6090507@in.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Mar 2010 01:28:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 12:44 AM, Sachin Sant wrote:
> Today's next failed to boot on x86 box with following trace
> 
> Unpacking initramfs...
> Freeing initrd memory: 10584k freed
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e
> *pdpt = 00000000005dd001 *pde = 0000000000000000
> Oops: 0000 [#1] SMP
> last sysfs file:
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted 2.6.33-autotest-next-20100303 #1
> /eserver xSeries 235 -[86717AX]-
> EIP: 0060:[<c01a6b12>] EFLAGS: 00010002 CPU: 1
> EIP is at pcpu_alloc+0x1cb/0x75e
> EAX: 00000000 EBX: c05c4100 ECX: cccccccc EDX: 00000000
> ESI: 000000b0 EDI: 00000005 EBP: f5c69fa8 ESP: f5c69f2c
> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 1, ti=f5c68000 task=f5c66ce0 task.ti=f5c68000)
> Stack:
> 00000000 00000005 61746164 0a383d29 5f656400 61746164 00000004 000000b0
> <0> 000a3036 00000286 61637061 29656863 0a36313d c0579100 c058da30 f5c69f94
> <0> c01310be c05c41cc 00000028 c058da30 f5c69fa4 c0116a73 c0492091 c0492089
> Call Trace:
> [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
> [<c01310be>] ? log_buf_kexec_setup+0x3f/0x67
> [<c058da30>] ? crash_save_vmcoreinfo_init+0x0/0x31a
> [<c0116a73>] ? arch_crash_save_vmcoreinfo+0x37/0x3c
> [<c058d9ff>] ? crash_notes_memory_init+0x0/0x31
> [<c01a70be>] ? __alloc_percpu+0xa/0xc
> [<c058da11>] ? crash_notes_memory_init+0x12/0x31
> [<c0101139>] ? do_one_initcall+0x4c/0x131
> [<c057b352>] ? kernel_init+0x127/0x178
> [<c057b22b>] ? kernel_init+0x0/0x178
> [<c0102df6>] ? kernel_thread_helper+0x6/0x10
> Code: 45 a8 e9 65 ff ff ff 8b 4d 9c 8b 55 a0 8b 45 84 e8 31 fa ff ff 85
> c0 89 45 a4 0f 89 fd 00 00 00 8b 45 84 8b 00 89 45 84 8b 55 84 <8b> 02
> 0f 18 00 90 8b 45 cc 03 05 a0 9b 57 c0 39 c2 0f 85 67 ff
> EIP: [<c01a6b12>] pcpu_alloc+0x1cb/0x75e SS:ESP 0068:f5c69f2c
> CR2: 0000000000000000
> ---[ end trace a7919e7f17c0a725 ]---
> 
> x86_64 boots fine. Have attached dmesg log.

Can you please feed the address to gdb and get the line number?  Also,
is it reproducible on mainline?

Thanks.

-- 
tejun
