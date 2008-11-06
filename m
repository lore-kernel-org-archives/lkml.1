Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbYKFTQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbYKFTQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYKFTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:15:40 -0500
Received: from gw.goop.org ([64.81.55.164]:55504 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYKFTPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:15:38 -0500
Message-ID: <49134257.4000404@goop.org>
Date: Thu, 06 Nov 2008 11:15:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "Christopher S. Aker" <caker@theshore.net>,
       xen devel <xen-devel@lists.xensource.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] 2.6.27 - SMP enabled, but only 1 CPU
References: <48F3BC99.5040409@theshore.net> <490F5F50.7020704@theshore.net>	 <4910AD00.7040605@theshore.net>  <4911BC52.7040905@theshore.net> <1225994697.12607.837.camel@zakaz.uk.xensource.com>
In-Reply-To: <1225994697.12607.837.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Wed, 2008-11-05 at 10:31 -0500, Christopher S. Aker wrote:
>   
>> 2.6.28-rc3      - Brought up 1 CPUs, eventually dies with: 
>> http://p.linode.com/1408
>>     
>
> I've been seeing this too. I bisected it down to:
>
>         ab00fee30cddf975200b3c97aef25bea144a0d89 is first bad commit
>         commit ab00fee30cddf975200b3c97aef25bea144a0d89
>         Author: Jan Beulich <jbeulich@novell.com>
>         Date:   Thu Oct 30 10:37:21 2008 +0000
>         
>             i386/PAE: fix pud_page()
>             
>             Impact: cleanup
>             
>             To the unsuspecting user it is quite annoying that this broken and
>             inconsistent with x86-64 definition still exists.
>             
>             Signed-off-by: Jan Beulich <jbeulich@novell.com>
>             Signed-off-by: Ingo Molnar <mingo@elte.hu>
>         
>         :040000 040000 3b49a9d3792e9f02dd799ad4deb69922d2a085d0 f0136498ef53b36172dca595f11a784f43bebcea M	arch
>
> It's late so figuring out how it broke can wait for tomorrow.
>
> The interesting bit from the link given is below.
>   

Ah, OK.

Ingo, Jan:

Did this patch actually fix anything, or was it just a cleanup?  It 
seems to have broken 32-bit Xen in some way, so if its just a cleanup it 
would be best to drop it until we've worked out what's going on.

Thanks,
    J

> Ian.
>
>
> 1 multicall(s) failed: cpu 0
> Pid: 1, comm: swapper Not tainted 2.6.28-rc3-test1 #1
> Call Trace:
>  [<c0103e41>] xen_mc_flush+0xb1/0x180
>  [<c010478f>] xen_do_pin+0x3f/0x90
>  [<c0104e3f>] __xen_pgd_pin+0xcf/0x140
>  [<c0104f0d>] xen_activate_mm+0x1d/0x30
>  [<c018f12c>] flush_old_exec+0x29c/0x740
>  [<c018e2db>] kernel_read+0x3b/0x60
>  [<c01bd228>] load_elf_binary+0x198/0x16c0
>  [<c0104159>] xen_set_pte+0x19/0x30
>  [<c0173ef6>] handle_mm_fault+0xa46/0xc70
>  [<c01719be>] vm_normal_page+0x4e/0xa0
>  [<c0171cd9>] follow_page+0x2c9/0x320
>  [<c0174245>] __get_user_pages+0x125/0x3e0
>  [<c018e0ca>] get_arg_page+0x4a/0xb0
>  [<c01bd090>] load_elf_binary+0x0/0x16c0
>  [<c018fb32>] search_binary_handler+0xa2/0x230
>  [<c018fe88>] do_execve+0x1c8/0x210
>  [<c010685f>] sys_execve+0x2f/0x50
>  [<c01085b6>] syscall_call+0x7/0xb
>  [<c058007b>] sctp_setsockopt+0xd2b/0x1060
>  [<c01800d8>] sys_swapon+0x308/0xaf0
>  [<c010c4fc>] kernel_execve+0x1c/0x30
>  [<c0102292>] init_post+0xb2/0x100
>  [<c01092f3>] kernel_thread_helper+0x7/0x10
>   call  1/8: op=14 arg=[d5963000] result=0
>   call  2/8: op=14 arg=[d5964000] result=0
>   call  3/8: op=14 arg=[d5965000] result=0
>   call  4/8: op=14 arg=[d5968000] result=0
>   call  5/8: op=26 arg=[c12d5880] result=0
>   call  6/8: op=14 arg=[d5962000] result=0
>   call  7/8: op=14 arg=[c12b2000] result=0
>   call  8/8: op=26 arg=[c12d5890] result=-22
> BUG: unable to handle kernel paging request at c12b2d0c
> IP: [<c0106550>] xen_spin_unlock+0x0/0x10
> *pdpt = 00000002ccfb6027 
> Oops: 0003 [#1] SMP 
> last sysfs file: 
> Modules linked in:
>  
> Pid: 1, comm: swapper Not tainted (2.6.28-rc3-test1 #1) 
> EIP: 0061:[<c0106550>] EFLAGS: 00010002 CPU: 0
> EIP is at xen_spin_unlock+0x0/0x10
> EAX: c12b2d0c EBX: 00000001 ECX: 00000000 EDX: c12d5a80
> ESI: 00000001 EDI: c12d5a80 EBP: c12d5080 ESP: d603fd38
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: e021
> Process swapper (pid: 1, ti=d603e000 task=d603d8a0 task.ti=d603e000)
> Stack:
>  c0104245 c0103eb3 c062b9a4 00000008 00000008 0000001a c12d5890 ffffffea
>  00000000 00000003 00000000 00000000 d5960e40 c0104e3f 15966001 00000000
>  d5962000 d5960e40 d5960e84 d603d8a0 d603dbe4 c0104f0d d5960e40 c0699d00
> Call Trace:
>  [<c0104245>] xen_pte_unlock+0x5/0x10
>  [<c0103eb3>] xen_mc_flush+0x123/0x180
>  [<c0104e3f>] __xen_pgd_pin+0xcf/0x140
>  [<c0104f0d>] xen_activate_mm+0x1d/0x30
>  [<c018f12c>] flush_old_exec+0x29c/0x740
>  [<c018e2db>] kernel_read+0x3b/0x60
>  [<c01bd228>] load_elf_binary+0x198/0x16c0
>  [<c0104159>] xen_set_pte+0x19/0x30
>  [<c0173ef6>] handle_mm_fault+0xa46/0xc70
>  [<c01719be>] vm_normal_page+0x4e/0xa0
>  [<c0171cd9>] follow_page+0x2c9/0x320
>  [<c0174245>] __get_user_pages+0x125/0x3e0
>  [<c018e0ca>] get_arg_page+0x4a/0xb0
>  [<c01bd090>] load_elf_binary+0x0/0x16c0
>  [<c018fb32>] search_binary_handler+0xa2/0x230
>  [<c018fe88>] do_execve+0x1c8/0x210
>  [<c010685f>] sys_execve+0x2f/0x50
>  [<c01085b6>] syscall_call+0x7/0xb
>  [<c058007b>] sctp_setsockopt+0xd2b/0x1060
>  [<c01800d8>] sys_swapon+0x308/0xaf0
>  [<c010c4fc>] kernel_execve+0x1c/0x30
>  [<c0102292>] init_post+0xb2/0x100
>  [<c01092f3>] kernel_thread_helper+0x7/0x10
> Code: 6d c0 e8 d4 51 2c 00 83 f8 0f 89 c1 7f 1a 8b 04 8d 80 95 6d c0 39
> 34 03 75 e1 5b ba 03 00 00 00 89 c8 5e e9 73 c2 2d 00 5b 5e c3 <c6> 00
> 00 66 83 78 02 00 75 01 c3 eb b3 8d 76 00 0f 0b eb fe 8d 
> EIP: [<c0106550>] xen_spin_unlock+0x0/0x10 SS:ESP e021:d603fd38
> ---[ end trace 72dbea1e75327c37 ]--- 
>
>
>   

