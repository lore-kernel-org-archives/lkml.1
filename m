Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbXA1RmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbXA1RmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 12:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbXA1RmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 12:42:07 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:46250 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbXA1RmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 12:42:06 -0500
Message-ID: <45BCE067.5000603@gmail.com>
Date: Sun, 28 Jan 2007 18:41:59 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@suse.de>
Subject: Re: elevator oops [Was: 2.6.20-rc6-mm1]
References: <20070127234928.64d8e437.akpm@osdl.org> <45BC82A5.1020403@gmail.com>
In-Reply-To: <45BC82A5.1020403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Andrew Morton napsal(a):
>> Temporarily at
>>
>>     http://userweb.kernel.org/~akpm/2.6.20-rc6-mm1/
> 
> Under disk load I get disk:
> ------------[ cut here ]------------
> kernel BUG at /home/l/latest/xxx/block/cfq-iosched.c:1026!
> invalid opcode: 0000 [#1]
> SMP
> last sysfs file: /devices/platform/i2c-9191/9191-0290/cpu0_vid
> Modules linked in: nfsd exportfs lockd sunrpc cifs ipv6 floppy eth1394 
> ide_cd ohci1394 cdrom usb_storage ehci_hcd ieee1394
> CPU:    0
> EIP:    0060:[<c01d4186>]    Not tainted VLI
> EFLAGS: 00010002   (2.6.20-rc6-mm1 #228)
> EIP is at cfq_dispatch_requests+0x497/0x49b
> eax: 00000000   ebx: 00000000   ecx: 00000001   edx: 00000000
> esi: 00000000   edi: f7e739c0   ebp: f7e9bcf0   esp: f7e9bca0
> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
> Process md3_raid1 (pid: 415, ti=f7e9a000 task=c1961570 task.ti=f7e9a000)
> Stack: 00000000 c1961570 00000001 00000001 0000019f f7e72d5c c01d2fd1 
> f7e74574
>        00000000 f7e7180c 00000000 00000000 c01cb837 f7e7180c 00000001 
> f7e9bd04
>        c01ce7a4 f7e7180c f7e7180c f7e7180c f7e9bd08 c01cb99b f7e74574 
> f7e7180c
> Call Trace:
>  [<c0104ffb>] show_trace_log_lvl+0x1a/0x30
>  [<c01050b6>] show_stack_log_lvl+0xa5/0xca
>  [<c01052ae>] show_registers+0x1d3/0x2b8
>  [<c01054b4>] die+0x121/0x243
>  [<c010564c>] do_trap+0x76/0x9c
>  [<c0105eb1>] do_invalid_op+0x97/0xa1
>  [<c034df3c>] error_code+0x7c/0x84
>  [<c01cb99b>] elv_drain_elevator+0x18/0x62
>  [<c01cbf53>] elv_insert+0xa2/0x111
>  [<c01cc035>] __elv_add_request+0x73/0x76
>  [<c01cfdff>] __make_request+0xd9/0x2f5
>  [<c01cde61>] generic_make_request+0x158/0x1f9
>  [<c01d0161>] submit_bio+0x53/0xd6
>  [<c02859a8>] md_super_write+0x87/0xa3
>  [<c0285c39>] md_update_sb+0x275/0x3f4
>  [<c02899fe>] md_check_recovery+0x17f/0x466
>  [<c0281380>] raid1d+0x2e/0xf9c
>  [<c028b47f>] md_thread+0x32/0x113
>  [<c0134c5b>] kthread+0xb4/0xd9
>  [<c0104c9f>] kernel_thread_helper+0x7/0x18
>  =======================
> Code: 10 c7 04 24 00 00 00 00 31 c9 89 f8 e8 e4 f1 ff ff 8b 4f 5c 85 c9 
> 75 13 8b 55 d8 8d 04 13 01 f0 03 45 dc 89 45 d0 e9 86 fb ff ff <0f> 0b 
> eb fe 55 89 e5 57 56 53 83 ec 04 89 c3 8b 40 54 89 45 f0
> EIP: [<c01d4186>] cfq_dispatch_requests+0x497/0x49b SS:ESP 0068:f7e9bca0
> 
> and the kernel (totally) hangs (no sysrq).

noop scheluder seems to be stable altogether.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
