Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbYASDGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbYASDGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 22:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759879AbYASDGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 22:06:35 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:48113 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158AbYASDGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 22:06:34 -0500
Date: Sat, 19 Jan 2008 04:06:31 +0100
Message-Id: <112790498@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: kamalesh@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.23-rc9 kernel panic - simple_map_write+0x4e/0x75
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18twAi76bbPX+uelcKY7xa8+7hq+40vDg0ALJZ8zYnl+vxWP
 DuAKXUdp333W2saYvQBBcicTCt8mAI399CghJQeOpBJ3uFhTYY=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks very similar to

http://marc.info/?l=linux-kernel&m=119759817332220&w=2
http://marc.info/?l=linux-kernel&m=119902059626408&w=2
http://marc.info/?l=linux-kernel&m=119259674826979&w=2
http://lkml.org/lkml/2006/6/14/59

so you should try without CONFIG_MTD_PNC2000 

that driver having problems for some time (first report seems 2.6.17 ) - i have found same issue (independently) on 2.6.22 and 2.6.24, too.

i have some updated information regarding this driver i will post here very soon, but please confirm if this is the issue here (i`m quite sure it is)

regards
roland


Subject:    Re: [BUG] 2.6.23-rc9 kernel panic - simple_map_write+0x4e/0x75
From:       Kamalesh Babulal <kamalesh () linux ! vnet ! ibm ! com>
Date:       2007-10-17 7:23:33
Message-ID: 4715B5A5.9050005 () linux ! vnet ! ibm ! com
[Download message RAW]

Andrew Morton wrote:
> On Sat, 13 Oct 2007 12:10:44 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Kernel panic's with following oops message with 2.6.23-rc9 kernel 
>>
>> [  320.747257] ks0108: ERROR: parport didn't register new device
>> [  320.771314] cfag12864b: ERROR: ks0108 is not initialized
>> [  320.794308] cfag12864bfb: ERROR: cfag12864b is not initialized
>> [  320.820729] BUG: unable to handle kernel paging request at virtual address
>> bf000000
>> [  320.857712]  printing eip:
>> [  320.872556] *pde = 00000000
>> [  320.887577] Oops: 0002 [#1]
>> [  320.902383] SMP 
>> [  320.914174] Modules linked in:
>> [  320.929333] CPU:    0
>> [  320.929334] EIP:    0060:[<c0d7e4e2>]    Not tainted VLI
>> [  320.929335] EFLAGS: 00010286   (2.6.23-rc9-1 #1)
>> [  320.982753] EIP is at simple_map_write+0x4e/0x75
>> [  321.001956] eax: f0f0f0f0   ebx: c1de3f00   ecx: c1de3f00   edx: c1de3f00
>> [  321.027701] esi: c3ca8d6c   edi: bf000000   ebp: c3ca8d98   esp: c3ca8d6c
>> [  321.053322] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
>> [  321.075981] Process swapper (pid: 1, ti=c3ca8000 task=f7f44000 task.ti=c3ca8000)
>> [  321.103031] Stack: f0f0f0f0 00000000 00000000 00000000 00000000 00000000
>> 00000000 00000000 
>> [  321.139446]        c3ca8e20 00000001 c3ca8e40 c3ca8e6c c0d692e6 f0f0f0f0
>> 00000000 00000000 
>> [  321.176495]        00000000 00000000 00000000 00000000 00000000 00000000
>> 00000000 000050e6 
>> [  321.214141] Call Trace:
>> [  321.233922]  [<c0107dff>] show_trace_log_lvl+0x19/0x2e
>> [  321.255433]  [<c0107ec1>] show_stack_log_lvl+0x99/0xa1
>> [  321.276706]  [<c01080c4>] show_registers+0x1b8/0x290
>> [  321.297254]  [<c01082f9>] die+0x118/0x1fd
>> [  321.314920]  [<c145014a>] do_page_fault+0x51c/0x5f3
>> [  321.335291]  [<c144e6da>] error_code+0x72/0x78
>> [  321.354413]  [<c0d692e6>] cfi_probe_chip+0x148/0x9e1
>> [  321.375202]  [<c0d7bb3e>] genprobe_new_chip+0x82/0x98
>> [  321.396298]  [<c0d7b8dd>] genprobe_ident_chips+0x26/0x205
>> [  321.418493]  [<c0d7b830>] mtd_do_chip_probe+0x10/0x97
>> [  321.439654]  [<c0d6a29e>] cfi_probe+0xd/0xf
>> [  321.458157]  [<c0d68d57>] do_map_probe+0x40/0x53
>> [  321.477931]  [<c200d748>] init_pnc2000+0x3b/0x6d
>> [  321.497559]  [<c1fa382c>] do_initcalls+0x7a/0x1c2
>> [  321.517377]  [<c1fa3990>] do_basic_setup+0x1c/0x1e
>> [  321.537327]  [<c1fa3a2c>] kernel_init+0x69/0xaa
>> [  321.556311]  [<c0107c2b>] kernel_thread_helper+0x7/0x10
>> [  321.577207]  =======================
>> [  321.592882] Code: 83 f8 01 75 0a 03 7b 10 8b 45 d4 88 07 eb 35 83 f8 02 75 0c
>> 0f b7 45 d4 03 7b 10 66 89 07 eb 24 83 f8 04 75 0a 03 7b 10 8b 45 d4 <89> 07 eb
>> 15 7e 13 03 7b 10 89 c1 c1 e9 02 f3 a5 89 c1 83 e1 03 
>> [  321.668990] EIP: [<c0d7e4e2>] simple_map_write+0x4e/0x75 SS:ESP 0068:c3ca8d6c
>> [  321.695750] Kernel panic - not syncing: Attempted to kill init!
> 
> Would I be correct in assuming that the machine has no mtd devices, but
> you happened to link that driver into your vmlinux?
> 

Hi Andrew,

The machine do not have the mtd device, and the mtd is compiled into the vmlinuz.
This configuration works fine for other kernels and is reproducible with
2.6.23-rc9 only.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

_____________________________________________________________________
Unbegrenzter Speicherplatz für Ihr E-Mail Postfach? Jetzt aktivieren!
http://www.digitaledienste.web.de/freemail/club/lp/?lp=7

