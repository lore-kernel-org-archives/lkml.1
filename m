Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYAIW6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYAIW6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbYAIW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:58:23 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:47159 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbYAIW6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:58:21 -0500
Message-ID: <478550DF.3070908@web.de>
Date: Wed, 09 Jan 2008 23:55:27 +0100
From: Torben Viets <viets@web.de>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: LRW/XTS + Via Padlock Bug in 2.6.24-rc7?
References: <47841152.8080705@web.de>
In-Reply-To: <47841152.8080705@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19xXVVjoTRDBOX4CQUyzOOvE1VdxLv9Z4BVKvts
	lXySeUyo8n7Snedc2KqTuJyA3n/onktOPgI1IZsblOmlteC5Wt
	JBxGUxXu8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

I've tried a little bit more with the XTS and the LRW Cipher, XTS is 
unuseable it crashes with the kernel panic below. LRW doenst work in 
2.6.23.12 with/without the patch from 
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg244470.html 
or with 2.6.24-rc7

My System ist Ubuntu 7.10 with cryptsetup 2:1.0.5-2ubuntu2

everytime I use cryptsetup -c aes-lrw-benbi -s 256 luksFormat /dev/raid/test

I get the following in dmesg:

eneral protection fault: 0000 [#1]
Modules linked in: xt_TCPMSS xt_tcpmss iptable_mangle ipt_MASQUERADE 
xt_tcpudp xt_mark xt_state iptable_nat nf_nat nf_conntrack_ipv4 
iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc 
aes_i586
CPU:    0
EIP:    0060:[<c035b828>]    Not tainted VLI
EFLAGS: 00010292   (2.6.23.12 #7)
EIP is at aes_crypt_copy+0x28/0x40
eax: f7639ff0   ebx: f6c24050   ecx: 00000001   edx: f6c24030
esi: f7e89dc8   edi: f7639ff0   ebp: 00010000   esp: f7e89dc8
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process kcryptd/0 (pid: 937, ti=f7e88000 task=f7d85ab0 task.ti=f7e88000)
Stack: dd7f6714 1b8c0a97 19fd5394 4492154e f7e89ef8 c0262f42 0000007b 
f7e89ec8
       f6c24050 f7639ff0 f7639ff0 c035bda6 f6c24030 00000000 f7639ff0 
f7e89e28
       c02681e6 f7639ff0 f76c6020 f7e89e58 f7e89ec8 00000010 f7e89ea0 
00000010
Call Trace:
 [<c0262f42>] blkcipher_walk_next+0x132/0x2f0
 [<c035bda6>] aes_decrypt+0x56/0x60
 [<c02681e6>] crypt+0xe6/0x220
 [<c035bd50>] aes_decrypt+0x0/0x60
 [<c0268352>] decrypt+0x32/0x40
 [<c035bd50>] aes_decrypt+0x0/0x60
 [<c0357d5e>] crypt_convert_scatterlist+0x6e/0xe0
 [<c0271e43>] __make_request+0x1a3/0x480
 [<c0357f08>] crypt_convert+0x138/0x150
 [<c03580e0>] kcryptd_do_work+0x0/0x310
 [<c0358333>] kcryptd_do_work+0x253/0x310
 [<c0118647>] update_stats_wait_end+0xa7/0xe0
 [<c03580e0>] kcryptd_do_work+0x0/0x310
 [<c012a206>] run_workqueue+0x66/0xe0
 [<c012a9e0>] worker_thread+0x0/0x100
 [<c012aa7d>] worker_thread+0x9d/0x100
 [<c012d5c0>] autoremove_wake_function+0x0/0x50
 [<c012a9e0>] worker_thread+0x0/0x100
 [<c012d282>] kthread+0x42/0x70
 [<c012d240>] kthread+0x0/0x70
 [<c0104acf>] kernel_thread_helper+0x7/0x18
 =======================
Code: 90 90 90 83 ec 2c 89 5c 24 20 89 cb 89 74 24 24 89 c6 89 d0 89 7c 
24 28 8b 54 24 30 89 e7 a5 a5 a5 a5 b9 01 00 00 00 89 e6 89 c7 <f3> 0f 
a7 c8 8b 5c 24 20 8b 74 24 24 8b 7c 24 28 83 c4 2c c3 8d
EIP: [<c035b828>] aes_crypt_copy+0x28/0x40 SS:ESP 0068:f7e89dc8
note: kcryptd/0[937] exited with preempt_count 1

I'm not on the list, please CC me.

Thanks and greetings
Torben Viets


Torben Viets wrote:
> Hello,
>
> I have a Via Epia Sn1000 Board with a padlock-aes crypto accelerator, 
> if I uses this with cryptsetup and LRW or XTS, I get a kernel panic 
> and cryptsetup never ends.
>
> XTS:
> cryptsetup -c aes-xts-plain -s 256 luksFormat /dev/raid/test
>
> general protection fault: 0000 [#1]
> Modules linked in: lrw padlock_aes xts xt_TCPMSS xt_tcpmss 
> iptable_mangle pppoe pppox ipt_MASQUERADE xt_tcpudp iptable_nat nf_nat 
> nf_conntrack_ipv4 iptable_filter ip_tables x_tables af_packet 
> ppp_generic slhc aes_i586 dm_crypt dm_mod
>
> Pid: 5991, comm: kcryptd Not tainted (2.6.24-rc7 #4)
> EIP: 0060:[<f88cf028>] EFLAGS: 00010296 CPU: 0
> EIP is at aes_crypt_copy+0x28/0x40 [padlock_aes]
> EAX: f6385ff0 EBX: f61ce450 ECX: 00000001 EDX: f61ce430
> ESI: f6235dac EDI: f6385ff0 EBP: f6235e00 ESP: f6235dac
> DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process kcryptd (pid: 5991, ti=f6234000 task=f63fcab0 task.ti=f6234000)
> Stack: 811cd642 f3a4d1ea d12d0cfa 3098ed1e 00000000 ffffff24 c02695d8 
> 00000060
>       f61ce450 f6385ff0 f6385ff0 f88cf096 f61ce430 f6385ff0 f6385ff0 
> 00000010
>       f88c90fc f581f3e0 f6235e34 f6235ea8 00000010 f89b59df c29b34ff 
> 391d88f0
> Call Trace:
> [<c02695d8>] gf128mul_x_ble+0x68/0x90
> [<f88cf096>] aes_decrypt+0x56/0x60 [padlock_aes]
> [<f88c90fc>] crypt+0xdc/0x110 [xts]
> [<f88cf040>] aes_decrypt+0x0/0x60 [padlock_aes]
> [<f88c9222>] decrypt+0x42/0x50 [xts]
> [<f88cf810>] aes_encrypt+0x0/0x60 [padlock_aes]
> [<f88cf040>] aes_decrypt+0x0/0x60 [padlock_aes]
> [<f886a7de>] crypt_convert_scatterlist+0x6e/0xe0 [dm_crypt]
> [<f886a9ea>] crypt_convert+0x19a/0x1c0 [dm_crypt]
> [<f886aa10>] kcryptd_do_crypt+0x0/0x260 [dm_crypt]
> [<f886aa59>] kcryptd_do_crypt+0x49/0x260 [dm_crypt]
> [<c01195c0>] update_curr+0x70/0x110
> [<f886aa10>] kcryptd_do_crypt+0x0/0x260 [dm_crypt]
> [<c012b116>] run_workqueue+0x66/0xe0
> [<c03f5279>] schedule+0x149/0x270
> [<c012b8f0>] worker_thread+0x0/0x100
> [<c012b98d>] worker_thread+0x9d/0x100
> [<c012e790>] autoremove_wake_function+0x0/0x50
> [<c012b8f0>] worker_thread+0x0/0x100
> [<c012e452>] kthread+0x42/0x70
> [<c012e410>] kthread+0x0/0x70
> [<c0104acf>] kernel_thread_helper+0x7/0x18
> =======================
> Code: <f3> 0f a7 c8 8b 5c 24 20 8b 74 24 24 8b 7c 24 28 83 c4 2c c3 8d 74
> EIP: [<f88cf028>] aes_crypt_copy+0x28/0x40 [padlock_aes] SS:ESP 
> 0068:f6235dac
> ---[ end trace 9ae4eb03d4e4c477 ]---
> note: kcryptd[5991] exited with preempt_count 1
>
> I'm not on the lklm, so please CC me.
>
> I hope you have enough information.
>
> Thank you and greetings
> Torben Viets
>
>
>
>

