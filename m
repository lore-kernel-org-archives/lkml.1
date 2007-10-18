Return-Path: <linux-kernel-owner+w=401wt.eu-S1765153AbXJREZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765153AbXJREZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 00:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXJREZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 00:25:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:40082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750990AbXJREZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 00:25:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Gh2Ih5tCGu3ek/h4plm6qWbXBIqLFGxOkU1+jb6
	tfhDSQZAj2+zdI
Subject: [microcode] 2.6.23.git pulled this morning oopses loading P4
	microcode
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 06:25:33 +0200
Message-Id: <1192681533.7147.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Freshly pulled tree oopes per $subject.

[  114.714335] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000031
[  114.732810] printing eip: c03332ff *pde = 00000000 
[  114.747614] Oops: 0000 [#1] PREEMPT SMP 
[  114.761320] Modules linked in: microcode snd_seq edd button battery ac ip6t_REJECT xt_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter ip6_tables x_tables nls_iso8859_1 nls_cp437 nls_utf8 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_mpu401 snd_timer snd_mpu401_uart snd_rawmidi prism54 snd_page_alloc snd_seq_device snd soundcore intel_agp agpgart i2c_i801 fan thermal processor
[  114.781462] CPU:    0
[  114.781464] EIP:    0060:[<c03332ff>]    Not tainted VLI
[  114.781468] EFLAGS: 00010293   (2.6.23-smp-git #13)
[  114.781478] EIP is at misc_register+0x53/0x14f
[  114.781483] eax: 00000025   ebx: f8bff858   ecx: f8bff900   edx: 00000031
[  114.781490] esi: 000000b8   edi: f8bff864   ebp: c2e0de88   esp: c2e0de68
[  114.781496] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  114.781502] Process modprobe (pid: 6115, ti=c2e0d000 task=c2efa070 task.ti=c2e0d000)
[  114.781508] Stack: c1cb4070 f8bff900 c2e0de88 c014818c f8bff900 f8bff900 f8bff900 00000029 
[  114.781521]        c2e0de9c f8bac011 c01368e6 ffffffff f8bff900 c2e0dfb0 c0149dfa 00000000 
[  114.781533]        00000000 00002000 c04d4060 c2e0ded0 c2e0df58 f8be0058 f8be0054 f8bff948 
[  114.781545] Call Trace:
[  114.781548]  [<c010514a>] show_trace_log_lvl+0x1a/0x30
[  114.781558]  [<c0105205>] show_stack_log_lvl+0xa5/0xca
[  114.781564]  [<c0105426>] show_registers+0x1fc/0x33d
[  114.781571]  [<c010567d>] die+0x116/0x239
[  114.781577]  [<c011d008>] do_page_fault+0x2dc/0x5c4
[  114.781585]  [<c04c0662>] error_code+0x72/0x78
[  114.781594]  [<f8bac011>] microcode_init+0x11/0xbb [microcode]
[  114.781604]  [<c0149dfa>] sys_init_module+0xef/0x19bb
[  114.781612]  [<c01041ba>] syscall_call+0x7/0xb
[  114.781618]  =======================
[  114.781621] Code: 0c 0f 18 02 90 81 3d 60 d5 61 c0 60 d5 61 c0 0f 84 fb 00 00 00 8b 33 39 30 75 0d e9 a9 00 00 00 39 30 0f 84 a1 00 00 00 8d 42 f4 <8b> 50 0c 0f 18 02 90 3d 54 d5 61 c0 75 e7 81 fe ff 00 00 00 0f 
[  114.781677] EIP: [<c03332ff>] misc_register+0x53/0x14f SS:ESP 0068:c2e0de68

(gdb) list *misc_register+0x53
0xc03332ff is in misc_register (drivers/char/misc.c:194).
189             int err = 0;
190
191             INIT_LIST_HEAD(&misc->list);
192
193             mutex_lock(&misc_mtx);
194             list_for_each_entry(c, &misc_list, list) {
195                     if (c->minor == misc->minor) {
196                             mutex_unlock(&misc_mtx);
197                             return -EBUSY;
198                     }




