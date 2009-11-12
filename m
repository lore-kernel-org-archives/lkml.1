Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZKLPqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZKLPqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 10:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZKLPqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 10:46:30 -0500
Received: from relay2.mail.masterhost.ru ([83.222.23.62]:49183 "EHLO
	relay2.mail.masterhost.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbZKLPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 10:46:30 -0500
Message-ID: <4AFC2DD7.5090407@mayc.ru>
Date: Thu, 12 Nov 2009 18:46:31 +0300
From: "Anton D. Kachalov" <mouse@mayc.ru>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
References: <4AFACC03.7080209@mayc.ru> <20091111162052.GD2448@hack>
In-Reply-To: <20091111162052.GD2448@hack>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-SpamTest-Envelope-From: mouse@mayc.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 10748 [Nov 12 2009]
X-SpamTest-Info: {HEADERS: 7-bit header Content-Type found with 8-bit header Content-Transfer-Encoding}
X-SpamTest-Method: none
X-SpamTest-Rate: 10
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo Wang wrote:
> On Wed, Nov 11, 2009 at 05:36:51PM +0300, Anton D. Kachalov wrote:
>   
>> Hello everyone!
>>
>> I've found strange behavior of reading /dev/mem:
>>
>> for i in 0 1 2; do
>>  echo $i
>>  dd if=/dev/mem of=/dev/null skip=$((6+$i)) bs=$((0x20000000)) count=1
>> done
>>
>> On some systems with Supermicro X8DTU I've got several messages during  
>> first 512Mb starting from 0xc000_0000:
>>
>>   "BUG: soft lockup - CPU#xx stuck for 61s!"
>>
>> On other systems with the sameboard I've stuck without any errors at  
>> last 10Mb before 0x1_0000_0000. Local APIC access?
>>     
>
>
> What is the full backtrace? And which version of kernel are you
> running?
>
>   
Ubuntu 2.6.28-16-server and 2.6.31-11-server.

Nov 10 17:59:10 localhost kernel: [  243.749254] BUG: soft lockup - 
CPU#11 stuck for 61s! [dd:4325]
Nov 10 17:59:10 localhost kernel: [  243.749256] Modules linked in: 
ip_queue ipt_LOG xt_limit ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state xt_tcpudp x
t_multiport xt_NOTRACK nf_conntrack iptable_raw video output 
iptable_filter ip_tables x_tables dummy parport_pc lp parport igb dca 
snd_pcm serio_raw snd_timer snd soundcore snd_page_alloc iTCO_wdt 
iTCO_vendor_support shpchp pcspkr raid10 raid456 raid6_pq async_xor 
async_memcpy async_tx xor raid1 raid0 multipath linear fbcon tileblit 
font bitblit softcursor
Nov 10 17:59:10 localhost kernel: [  243.749282] CPU 11:
Nov 10 17:59:10 localhost kernel: [  243.749284] Modules linked in: 
ip_queue ipt_LOG xt_limit ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state xt_tcpudp xt_multiport xt_NOTRACK nf_conntrack iptable_raw 
video output iptable_filter ip_tables x_tables dummy parport_pc lp 
parport igb dca snd_pcm serio_raw snd_timer snd soundcore snd_page_alloc 
iTCO_wdt iTCO_vendor_support shpchp pcspkr raid10 raid456 raid6_pq 
async_xor async_memcpy async_tx xor raid1 raid0 multipath linear fbcon 
tileblit font bitblit softcursor
Nov 10 17:59:10 localhost kernel: [  243.749305] Pid: 4325, comm: dd Not 
tainted 2.6.31-11-server #36ya3 X8DTU
Nov 10 17:59:10 localhost kernel: [  243.749307] RIP: 
0010:[<ffffffff81061fd5>]  [<ffffffff81061fd5>] r_next+0x5/0x30
Nov 10 17:59:10 localhost kernel: [  243.749316] RSP: 
0018:ffff88012b55fe48  EFLAGS: 00000206
Nov 10 17:59:10 localhost kernel: [  243.749317] RAX: ffff8800280211e0 
RBX: ffff88012b55fe88 RCX: 0000000000000118
Nov 10 17:59:10 localhost kernel: [  243.749319] RDX: ffff88012b55fe60 
RSI: ffff8800280211e0 RDI: 0000000000000000
Nov 10 17:59:10 localhost kernel: [  243.749320] RBP: ffffffff81012aee 
R08: 000000000000000e R09: ffffffff81795be0
Nov 10 17:59:10 localhost kernel: [  243.749322] R10: 8000000000000563 
R11: 8000000000000573 R12: ffffffff81516179
Nov 10 17:59:10 localhost kernel: [  243.749323] R13: ffff88012b55fdf8 
R14: ffffffff81078449 R15: ffff88012b55fda8
Nov 10 17:59:10 localhost kernel: [  243.749325] FS:  
00007fb8fe3646e0(0000) GS:ffff880028161000(0000) knlGS:0000000000000000
Nov 10 17:59:10 localhost kernel: [  243.749327] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Nov 10 17:59:10 localhost kernel: [  243.749328] CR2: 00007fb8de930000 
CR3: 000000012b4fd000 CR4: 00000000000006a0
Nov 10 17:59:10 localhost kernel: [  243.749330] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Nov 10 17:59:10 localhost kernel: [  243.749331] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 10 17:59:10 localhost kernel: [  243.749333] Call Trace:
Nov 10 17:59:10 localhost kernel: [  243.749337]  [<ffffffff8106294a>] ? 
iomem_is_exclusive+0x8a/0xb0
Nov 10 17:59:10 localhost kernel: [  243.749342]  [<ffffffff81037cbc>] ? 
devmem_is_allowed+0x2c/0x50
Nov 10 17:59:10 localhost kernel: [  243.749346]  [<ffffffff812e2828>] ? 
read_mem+0xa8/0x180
Nov 10 17:59:10 localhost kernel: [  243.749350]  [<ffffffff81117314>] ? 
vfs_read+0xc4/0x190
Nov 10 17:59:10 localhost kernel: [  243.749352]  [<ffffffff81117530>] ? 
sys_read+0x50/0x90
Nov 10 17:59:10 localhost kernel: [  243.749356]  [<ffffffff81011f42>] ? 
system_call_fastpath+0x16/0x1b

Same problem with soft lockup I have on this platform under heavy system 
load but I can't get backtrace for it...

